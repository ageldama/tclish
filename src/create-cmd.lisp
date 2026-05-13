(in-package :tclish)



(cffi:defctype cmd-cb-counter-t :uint64)

(defvar *tcl-cmd-cb-counter* 0)

(defvar *tcl-cmd-string-cb-ht* (make-hash-table))

(defvar *tcl-cmd-obj-cb-ht* (make-hash-table))

(defvar *tcl-cmd-lock* (bt2:make-lock :name "*tcl-cmd-lock*"))

(declaim (inline %cmd-cb-counter-value-from-c)
         (optimize (speed 1) (safety 3)))
(defun %cmd-cb-counter-value-from-c (c-val)
  (assert (not (cffi:null-pointer-p c-val)))
  (cffi:mem-ref c-val 'cmd-cb-counter-t))

(declaim (inline (setf %cmd-cb-counter-value-from-c))
         (optimize (speed 1) (safety 3)))
(defun (setf %cmd-cb-counter-value-from-c) (new-val c-val)
  (assert (not (cffi:null-pointer-p c-val)))
  (setf (cffi:mem-ref c-val 'cmd-cb-counter-t) new-val))


(defmacro %tcl-cmd-proc-cffi-callback-body
    (&key
       var-interp
       var-argc
       var-argv
       frlock
       cb-ht
       argc+argv-cvter
       )
  (let ((%cb-nr  (gensym))
        (%cb     (gensym)))
    `(bt2:with-lock-held (,frlock)
       (let* ((,%cb-nr      (%cmd-cb-counter-value-from-c client-data))
              (,%cb         (gethash ,%cb-nr ,cb-ht nil))) ;; mutex
         (assert (not (null ,%cb)))
         (let ((args  (,argc+argv-cvter ,var-argv ,var-argc)))
           (funcall ,%cb ,var-interp args))))))


(cffi:defcallback %tcl-cmd-proc-string-cb :int
    ((client-data   :pointer)
     (interp-ptr    tcl-interp-ptr)
     (argc          :int)
     (argv          (:pointer (:pointer :char))))
  "typedef int (Tcl_CmdProc)
(void *clientData, Tcl_Interp *interp, int argc, const char *argv[]);"
  (%tcl-cmd-proc-cffi-callback-body
   :var-interp interp-ptr
   :var-argc   argc
   :var-argv   argv
   :frlock *tcl-cmd-lock*
   :cb-ht *tcl-cmd-string-cb-ht*
   :argc+argv-cvter c-string-array-to-string-list))


(cffi:defcallback %tcl-cmd-proc-obj-cb :int
    ((client-data   :pointer)
     (interp-ptr    tcl-interp-ptr)
     (argc          tcl-size)
     (argv          (:pointer tcl-obj-ptr)))
  "typedef int (Tcl_ObjCmdProc2)
(void *clientData, Tcl_Interp *interp, Tcl_Size objc, struct Tcl_Obj *const *objv);"
  (%tcl-cmd-proc-cffi-callback-body
   :var-interp interp-ptr
   :var-argc   argc
   :var-argv   argv
   :frlock *tcl-cmd-lock*
   :cb-ht *tcl-cmd-obj-cb-ht*
   :argc+argv-cvter c-ptr-array-to-ptr-list))


(cffi:defcallback %tcl-cmd-delete-proc-cb :void
    ((client-data  :pointer))
  "typedef void (Tcl_CmdDeleteProc) (void *clientData);"
  (let ((cb-nr  (%cmd-cb-counter-value-from-c client-data)))
    (remhash cb-nr *tcl-cmd-string-cb-ht*) ;; mutex
    (remhash cb-nr *tcl-cmd-obj-cb-ht*)    ;; mutex
    (cffi:foreign-free client-data)))


(defmacro %defun-create-command
    (defun-name
     (&key
        frlock
        counter
        cb-ht
        cmd-proc-cb
        (cmd-del-cb '%tcl-cmd-delete-proc-cb)
        tcl-create-command-fn))
  "`defun-name'으로 create-command* 하는 함수를 등록.

그 함수는 `(interp cmd-name func) => (cons cmd-nr tcl-command-ptr)'

func은 `(interp args) => int'. 리턴값은 +tcl-ok+ / +tcl-error+."
  (let ((%new-cb-nr (gensym))
        (%c-cb-nr   (gensym))
        (%new-cmd   (gensym)))
    `(defun ,defun-name (interp cmd-name func)
       (bt2:with-lock-held (,frlock)
         (let* ((,%new-cb-nr   (incf ,counter))  ;; mutex(W)
                (,%c-cb-nr     (cffi:foreign-alloc 'cmd-cb-counter-t))
                (*tcl-interp*  interp)
                (,%new-cmd     nil))
           (setf (cffi:mem-ref ,%c-cb-nr 'cmd-cb-counter-t)
                 ,%new-cb-nr)
           ;; mutex(W)
           (setf (gethash ,%new-cb-nr ,cb-ht) func)
           (setf ,%new-cmd
                 (,tcl-create-command-fn
                  *tcl-interp* cmd-name
                  (cffi:callback ,cmd-proc-cb)
                  ,%c-cb-nr
                  (cffi:callback ,cmd-del-cb)))
           ;;
           (cons ,%new-cb-nr ,%new-cmd))))))


(%defun-create-command create-string-command
    (:frlock *tcl-cmd-lock*
     :counter *tcl-cmd-cb-counter*
     :cb-ht   *tcl-cmd-string-cb-ht*
     :cmd-proc-cb %tcl-cmd-proc-string-cb
     :tcl-create-command-fn tcl-create-command))

(%defun-create-command create-obj-command
    (:frlock *tcl-cmd-lock*
     :counter *tcl-cmd-cb-counter*
     :cb-ht   *tcl-cmd-obj-cb-ht*
     :cmd-proc-cb %tcl-cmd-proc-obj-cb
     :tcl-create-command-fn tcl-create-obj-command2))




(defun wrap-result (interp val)
  (typecase val
    (null    (tcl-reset-result interp))
    (t       (let* ((str-rep  (format nil "~a" val))
                    (bytes    (cffi:foreign-string-alloc str-rep))
                    (byte-len (c-strlen bytes)))
               (unwind-protect (tcl-set-obj-result
                                interp
                                (tcl-new-string-obj bytes byte-len))
                 ;; cleanup
                 (cffi:foreign-free bytes)))))
  ;;
  +tcl-ok+)


(defun wrap-error* (interp err)
  (let ((err-1  "LISP-ERROR")
        (err-2  (symbol-name (class-name (class-of err)))))
    (tcl-set-error-code interp
                        :string err-1
                        :string err-2
                        :pointer (cffi:null-pointer))
    (let* ((str-rep  (format nil "~a" err))
           (bytes    (cffi:foreign-string-alloc str-rep))
           (byte-len (c-strlen bytes)))
      (unwind-protect (tcl-set-obj-result
                       interp
                       (tcl-new-string-obj bytes byte-len))
        ;; cleanup
        (cffi:foreign-free bytes)))
    ;; result:
    (list err-1 err-2)))


(defun wrap-error (interp err)
  (wrap-error* interp err)
  +tcl-error+)


(defvar *def-cmd-ns* "")

(defvar *def-cmd-tracker* nil)

(defun %compose-ns-fqn (ns name)
  (if (zerop (length ns))
      name
      ;; else:
      (concatenate 'string ns "::" name)))


(defmacro def-cmd
    ((name
      &key
        (interp     '*tcl-interp*)
        (lambda-list '(interp args))
        (args-type  :strings)  ;; (:strings :objs)
        (ns         '*def-cmd-ns*)
        (wrap-p     t))
     &rest body)

  (let* ((create-command-func
           (case args-type
             (:strings 'create-string-command)
             (:objs    'create-obj-command)
             (t
              (error "Unsupported args-type (should be :strings or :objs)"))))
         (%result   (gensym))
         (%fqn-name (gensym))
         (wrapped-body
           (if wrap-p
               `((handler-case
                     (let ((,%result (progn ,@body)))
                       (wrap-result ,interp ,%result))
                   (error (c) (wrap-error ,interp c))))
               body)))

    `(let ((,%fqn-name (%compose-ns-fqn ,ns ,name)))
       (when *def-cmd-tracker*
         (funcall *def-cmd-tracker* ,%fqn-name :ns ,ns :name ,name))
       ;;
       (,create-command-func
        ,interp
        ,%fqn-name
        (lambda ,lambda-list
          (declare (ignorable ,@lambda-list))
          ,@wrapped-body)))))



