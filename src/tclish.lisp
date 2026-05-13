
(defpackage #:tclish
  (:use #:cl #:iterate #:raw-cffi-tcl9 #:tclish/cffi)
  (:export
   #:*tcl-interp*
   #:*do+chk/error?*
   #:do+chk

   #:mnt-zipfs
   #:umnt-zipfs

   #:create-string-command
   #:create-obj-command

   #:queue-evt-func

   #:create-command
   #:interp
   #:args

   #:queue-evt
   #:interp
   #:thread-id
   #:cb-counter

   #:cmd/p

   #:->tcl-string-obj
   #:list->tcl-string-objs
   #:kv-list->dict

   #:list-of-tcl-obj->tcl-list-obj
   #:list-to-pointer-array
   #:free-pointer-array

   #:apply-lambda

   #:wrap-error*
   #:wrap-error
   #:wrap-result
   ))


(in-package :tclish)





(defvar *tcl-interp* nil)


(defvar *do+chk/error?* t)

(defmacro do+chk
    ((fn-name
      &key
        (interp '*tcl-interp*)
        (tcl-ok +tcl-ok+)
        (error? '*do+chk/error?*)
        (include-error-info? t))
     &rest args)
  (let ((%rc (gensym))
        (%err-msg (gensym)))
    `(let ((,%rc (funcall (fdefinition (quote ,fn-name)) ,@args)))
       (unless (eq ,tcl-ok ,%rc)
         (let ((,%err-msg
                 (format nil "~a FAIL(ret=~a): ~a"
                         (quote ,fn-name)
                         ,%rc
                         (if ,include-error-info?
                             (tcl-get-var ,interp "errorInfo" 0)
                             ;; else:
                             (tcl-get-string-result ,interp)))))
           (if ,error?
               (error ,%err-msg)
               ;; else:
               (format *error-output* "~a~%" ,%err-msg)))))))





(defun mnt-zipfs (zip-filename
                  &key
                    (mnt-point "//zipfs:/app")
                    zip-passwd
                    (tcl-library-path "/tcl_library")
                    (tk-library-path  "/tk_library"))
  (let ((tcl-library-path% (concatenate 'string mnt-point
                                        tcl-library-path))
        (tk-library-path%  (concatenate 'string mnt-point
                                        tk-library-path)))
    (unless (uiop:file-exists-p zip-filename)
      (error "no-zip-file ~a" zip-filename))
    (do+chk (tcl-zipfs-mount)
            *tcl-interp* zip-filename mnt-point zip-passwd)
    (do+chk (tcl-set-var)
            *tcl-interp*
            "tcl-library-path" tcl-library-path%
            +tcl-global-only+)
    (do+chk (tcl-set-var)
            *tcl-interp*
            "tk-library-path" tk-library-path%
            +tcl-global-only+))
  t)


(defun umnt-zipfs (&key (mnt-point "//zipfs:/app"))
  (do+chk (tcl-zipfs-unmount) *tcl-interp* mnt-point))





(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :sb-concurrency))

(cffi:defctype cmd-cb-counter-t :uint64)

(defvar *tcl-cmd-cb-counter* 0)

(defvar *tcl-cmd-string-cb-ht* (make-hash-table))

(defvar *tcl-cmd-obj-cb-ht* (make-hash-table))

(defvar *tcl-cmd-lock* (sb-concurrency:make-frlock))

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
    `(sb-concurrency:frlock-read (,frlock)
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
       (sb-concurrency:frlock-write (,frlock)
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




(defmacro create-command
    ((&key
        interp
        name
        (lambda-list '(interp args))
        (args-type  :strings)  ;; (:strings :objs)
        (wrap-p     t))
     &rest body)
  (let* ((create-command-func
           (case args-type
             (:strings 'create-string-command)
             (:objs    'create-obj-command)
             (t
              (error "Unsupported args-type (should be :strings or :objs)"))))
         (%result (gensym))
         (wrapped-body
           (if wrap-p
               `((handler-case
                     (let ((,%result (progn ,@body)))
                       (wrap-result ,interp ,%result))
                   (error (c) (wrap-error ,interp c))))
               body)))
    `(,create-command-func
      ,interp
      ,name
      (lambda ,lambda-list
        (declare (ignorable ,@lambda-list))
        ,@wrapped-body))))









(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :sb-concurrency))


(cffi:defctype tcl-ev-queue-cb-counter-t :uint64)


(cffi:defcstruct tcl-ev-queue-cb-evt-s
  (ev           (:struct raw-cffi-tcl9:tcl-event))
  (interp-ptr   raw-cffi-tcl9:tcl-interp-ptr)
  (thread-id    raw-cffi-tcl9:tcl-thread-id)
  (cb-counter   tcl-ev-queue-cb-counter-t))

(cffi:defctype tcl-ev-queue-cb-evt-s-ptr
    (:pointer (:struct tcl-ev-queue-cb-evt-s)))

(defvar *tcl-ev-queue-cb-counter* 0)

(defvar *tcl-ev-queue-cb-ht* (make-hash-table))

(defvar *tcl-ev-queue-lock* (sb-concurrency:make-frlock))


(defun %tcl-ev-queue-cb-counter/value-from-c (c-val)
  (assert (not (cffi:null-pointer-p c-val)))
  (cffi:mem-ref c-val 'tcl-ev-queue-cb-counter-t))

(defun (setf %tcl-ev-queue-cb-counter/value-from-c) (new-val c-val)
  (assert (not (cffi:null-pointer-p c-val)))
  (setf (cffi:mem-ref c-val 'tcl-ev-queue-cb-counter-t) new-val))





(cffi:defcallback %tcl-evt-proc-cb :int
    ((ev-ptr  tcl-event-ptr)
     (flags   :int))
  "typedef int (Tcl_EventProc) (Tcl_Event *evPtr, int flags);

Once the event source has finished handling the event it returns 1 to
indicate that the event can be re‐ moved from the queue.
"
  (declare (ignore flags)) ;; IDK what it is.
  (let ((cb-fdef      nil))
    ;; ev-ptr => (XXX*) => extract(queue-cb-counter -> queue-cb)
    (cffi:with-foreign-slots ((cb-counter interp-ptr thread-id)
                              ev-ptr (:struct tcl-ev-queue-cb-evt-s))
      ;; (format t "cb:~a / interp:~a / thr:~a~%"
      ;;         cb-counter interp-ptr thread-id)
      (sb-concurrency:frlock-write (*tcl-ev-queue-lock*)
        (setf cb-fdef (gethash cb-counter *tcl-ev-queue-cb-ht*))
        (assert (not (null cb-fdef)))
        (remhash cb-counter *tcl-ev-queue-cb-ht*))
      ;;
      (funcall cb-fdef interp-ptr thread-id cb-counter))))



(defun queue-evt-func
    (&key
       interp
       thread-id
       ;; function(interp thread-id cb-counter) => int.
       ev-queue-cb-fdef
       (queue-position :tcl-queue-tail)
       (thread-alert-p t))
  (sb-concurrency:frlock-write (*tcl-ev-queue-lock*)
    (let ((ev-ptr     (tcl-alloc (cffi:foreign-type-size
                                  '(:struct tcl-ev-queue-cb-evt-s))))
          (cb-counter (incf *tcl-ev-queue-cb-counter*)))
      (tclish/cffi:c-memset ev-ptr 0
                            (cffi:foreign-type-size
                             '(:struct tcl-ev-queue-cb-evt-s)))
      ;;
      (cffi:with-foreign-slots (((interp* interp-ptr)
                                 (thread-id* thread-id)
                                 (cb-counter* cb-counter))
                                ev-ptr (:struct tcl-ev-queue-cb-evt-s))
        (setf (gethash cb-counter *tcl-ev-queue-cb-ht*) ev-queue-cb-fdef)

        (cffi:with-foreign-slots (((proc     raw-cffi-tcl9::proc)
                                   (next-ptr raw-cffi-tcl9::next-ptr))
                                  (cffi:foreign-slot-pointer
                                   ev-ptr
                                   '(:struct tcl-ev-queue-cb-evt-s)
                                   'ev)
                                  (:struct tcl-event))
          (setf proc      (cffi:callback %tcl-evt-proc-cb)
                next-ptr  (cffi:null-pointer)))

        (setf interp*      interp
              thread-id*   thread-id
              cb-counter*  cb-counter)
        )

      (tcl-thread-queue-event
       thread-id ev-ptr
       (cffi:foreign-enum-value
        'raw-cffi-tcl9:tcl-queue-position
        queue-position))
      (when thread-alert-p (tcl-thread-alert thread-id)))))






(defmacro queue-evt
    ((&rest fwd-opts
      &key
        (cb-return-code 1)
        (lambda-list '(interp thread-id cb-counter))
      &allow-other-keys)
     &rest body)
  `(queue-evt-func ,@fwd-opts
                   :ev-queue-cb-fdef
                   (lambda ,lambda-list
                     (declare (ignorable ,@lambda-list))
                     ,@body
                     ,cb-return-code)))







(defun cmd/p (interp &key (cmd-name "p"))
  (create-command
      (:interp interp :name cmd-name)
      (format t "~{~A~}~%" (cdr tclish:args))))









(defun ->tcl-string-obj
    (val
     &key
       (str-func (lambda (v) (format nil "~a" v))))
  (let ((s-val  (funcall str-func val)))
    (cffi:with-foreign-string (cstr-val s-val)
      (tcl-new-string-obj cstr-val -1))))



(defun list->tcl-string-objs
    (lst &rest args)
  (iter (for i in lst)
    (if (cffi:pointerp i)
        (collect i)
        (collect (apply #'->tcl-string-obj
                        `(,i ,@args))))))



(defun kv-list->dict (interp lst)
  (let ((dict  (tcl-new-dict-obj)))
    (iter (for (k . v) in lst)
      (as k-obj = (->tcl-string-obj k))
      (if (listp v)
          (tcl-dict-obj-put interp dict
                            k-obj (kv-list->dict interp v))
          ;; else:
          (tcl-dict-obj-put interp dict
                            k-obj (->tcl-string-obj v))))
    dict))







(defun list-of-tcl-obj->tcl-list-obj (obj-list)
  (let ((list-ptr (tcl-new-list-obj 0 (cffi:null-pointer))))
    (dolist (obj obj-list)
      (tcl-list-obj-append-element (cffi:null-pointer)
                                   list-ptr obj))
    list-ptr))


(defun list-to-pointer-array (lisp-list)
  (let* ((count (length lisp-list))
         (array-ptr (cffi:foreign-alloc :pointer :count count)))
    (loop for i from 0
          for item in lisp-list
          do (setf (cffi:mem-aref array-ptr :pointer i) item))
    array-ptr))


(defun free-pointer-array (ptr-list)
  (cffi:foreign-free ptr-list))



(defun apply-lambda
    (interp lambda-str args
     &key (result-as-obj? nil))
  (let* ((lambda-obj (->tcl-string-obj lambda-str))
         (objs-args  (list->tcl-string-objs args))
         (objv-list  `(,(->tcl-string-obj "apply") ,lambda-obj ,@objs-args))
         (objv       (list-to-pointer-array objv-list))
         (result     nil))

    (unwind-protect
         (progn
           (dolist (i objv-list) (tcl-incr-ref-count i))
           (do+chk (tcl-eval-objv :interp interp :error? t)
                   interp (length objv-list) objv 0)
           (setf result
                 (if result-as-obj?
                     (tcl-get-obj-result interp)
                     (tcl-get-string-result interp)))
           (dolist (i objv-list) (tcl-decr-ref-count i))
           ;; done:
           result)
      ;; cleanup:
      (free-pointer-array objv))))




