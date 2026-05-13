(defpackage #:tclish/redir-to-outstream-chan
  (:use #:cl
        #:raw-cffi-tcl9
        #:tclish
        #:tclish/cffi
        )

  (:export
   :<redir-to-outstream-chan>
   :name
   :lisp-stream
   :trim
   :skip-0-len
   :chan-type-ptr
   :client-data
   :tcl-chan
   :tcl-std-chan-type

   :dealloc
   :regist
   :unregist
   ))


(in-package :tclish/redir-to-outstream-chan)






(cffi:defctype chan-instance-counter-t :uint16)

(defvar *chan-instance-counter* 0)

(defvar *registered-chan-ht* (make-hash-table))


(eval-when (:compile-toplevel :load-toplevel :execute)
  (require :sb-concurrency))


(defvar *lock* (sb-concurrency:make-frlock))


(defun %new-instance-counter ()
  (sb-concurrency:frlock-write (*lock*)
    (incf *chan-instance-counter*)))

(defun %put-instance (chan)
  (sb-concurrency:frlock-write (*lock*)
    (with-slots (client-data) chan
      (setf (gethash (cffi:mem-ref client-data
                                   'chan-instance-counter-t)
                     *registered-chan-ht*)
            chan))))

(defun %rem-instance (chan)
  (sb-concurrency:frlock-write (*lock*)
    (with-slots (client-data) chan
      (remhash (cffi:mem-ref client-data
                             'chan-instance-counter-t)
               *registered-chan-ht*))))





(cffi:defcallback output-proc :int
    ((client-data    :pointer)
     (buf            (:pointer :char))
     (to-write       :int)
     (err-code-ptr   (:pointer :int)))
  "int	(Tcl_DriverOutputProc)
(ClientData instanceData, CONST84 char *buf, int toWrite, int *errorCodePtr)"
  (handler-case
      (progn
        ;; pre-checks
        (assert (not (cffi:null-pointer-p client-data)))
        (assert (not (cffi:null-pointer-p buf)))
        (assert (not (cffi:null-pointer-p err-code-ptr)))
        (assert (>=  to-write 0))

        ;; (byte_t)(*`client-data`) => *redirect-streams*
        (let* ((nr   (cffi:mem-ref client-data
                                   'chan-instance-counter-t))
               (chan (gethash nr *registered-chan-ht*)))
          (assert nr (nr)
                  "NR: *CUR*=~a / *HT*=~a"
                  *chan-instance-counter*
                  (alexandria:hash-table-alist *registered-chan-ht*))
          (assert chan (chan)
                  "CHAN: NR=~A *CUR*=~a / *HT*=~a"
                  nr *chan-instance-counter*
                  (alexandria:hash-table-alist *registered-chan-ht*))

          ;;
          (with-slots (skip-0-len trim) chan
            (let ((s (cffi:foreign-string-to-lisp buf :count to-write)))
              (when trim
                (setf s (case trim
                          (:left  (str:trim-left s))
                          (:right (str:trim-right s))
                          (:both  (str:trim s))
                          (t      (funcall trim s)))))
                (unless (and (zerop (length s)) skip-0-len)
                  (format (lisp-stream chan) "~a" s)))))
        ;; 처리한 바이트수 반환:
        to-write)
    (error (c)
      (format *error-output* "[ERROR] ~a~%" c)
      to-write)))


(cffi:defcallback close2-proc :int
    ((client-data :pointer)
     (interp-ptr  :pointer)
     (flags       :int))
  (declare (ignorable client-data interp-ptr flags))
  0)

(cffi:defcallback input-proc :int
    ((client-data   :pointer)
     (buf           (:pointer :char))
     (to-read       :int)
     (err-code-ptr  (:pointer :int)))
  (declare (ignorable client-data buf to-read))
  ;;     *errPtr = EINVAL;
  (setf (cffi:mem-ref err-code-ptr :int) 22)
  ;; 읽기 불가
  -1)

(cffi:defcallback watch-proc :void
    ((client-data :pointer)
     (mask        :int))
  (declare (ignorable client-data mask)))

(cffi:defcallback get-handle-proc :int
    ((client-data  :pointer)
     (direction    :int)
     (handle-ptr   (:pointer :pointer)))
  (declare (ignorable client-data direction handle-ptr))
  +tcl-error+)


(defclass <redir-to-outstream-chan> ()
  ((name               :type     string
                       :initarg  :name
                       :reader   name)
   (lisp-stream        :initarg  :lisp-stream
                       :reader   lisp-stream)
   (trim               :initarg  :trim
                       :initform nil
                       :documentation
                       "nil | :left | :right | :both | (func (str) -> str)"
                       :reader   trim)
   (skip-0-len         :type     boolean
                       :initarg  :skip-0-len
                       :initform t
                       :reader   skip-0-len)
   (chan-type-ptr      :initform nil
                       :reader   chan-type-ptr)
   (client-data        :initform nil
                       :reader   client-data)
   (tcl-chan           :initform nil
                       :reader   tcl-chan)
   (tcl-std-chan-type  :initform nil
                       :reader   tcl-std-chan-type)))


(defmethod initialize-instance :after
    ((chan <redir-to-outstream-chan>) &key)
  ;;
  (let ((instance-counter (%new-instance-counter)))
    (with-slots (chan-type-ptr client-data) chan
      (setf client-data ;=>
            (cffi:foreign-alloc 'chan-instance-counter-t
                                :initial-element instance-counter)
            chan-type-ptr ;=>
            (cffi:foreign-alloc '(:struct tcl-channel-type)))
      (mem-zero chan-type-ptr '(:struct tcl-channel-type))
      (cffi:with-foreign-slots ((type-name version output-proc
                                           close2-proc input-proc
                                           watch-proc get-handle-proc)
                                chan-type-ptr (:struct tcl-channel-type))
        (let ((chan-name-cstr (cffi:foreign-string-alloc (name chan))))
          (setf type-name   chan-name-cstr
                version     (cffi:make-pointer +tcl-channel-version-5+)
                input-proc           (cffi:callback input-proc)
                output-proc          (cffi:callback output-proc)
                watch-proc           (cffi:callback watch-proc)
                get-handle-proc      (cffi:callback get-handle-proc)
                close2-proc          (cffi:callback close2-proc)
                ))))))



(defmethod dealloc ((chan <redir-to-outstream-chan>))
  (%rem-instance chan)
  ;; CLIENT-data
  (with-slots (client-data) chan
    (unless (or (null client-data)
                (cffi:null-pointer-p client-data))
      (cffi:foreign-string-free client-data)
      (setf client-data nil)))
  ;; chan-type-ptr, (chan-type-ptr)->type-name
  (with-slots (chan-type-ptr) chan
    (unless (or (null chan-type-ptr)
                (cffi:null-pointer-p chan-type-ptr))
      (cffi:with-foreign-slots ((type-name)
                                chan-type-ptr (:struct tcl-channel-type))
        (unless (or (null type-name)
                    (cffi:null-pointer-p type-name))
          (cffi:foreign-string-free type-name)
          (setf type-name (cffi:null-pointer))))
      (cffi:foreign-free chan-type-ptr)
      (setf chan-type-ptr (cffi:null-pointer)))))


(defmethod regist
    ((chan <redir-to-outstream-chan>)
     &key
       tcl-interp-ptr
       tcl-std-chan-type)
  ;;
  (labels ((create-tcl-chan (chan)
             (with-slots (chan-type-ptr name client-data tcl-chan) chan
               (assert (null tcl-chan) (chan)
                       "Already Tcl_CreateChannel'd (~a)" chan)
               (setf tcl-chan ;=>
                     (tcl-create-channel chan-type-ptr name
                                         client-data +tcl-writable+))
               (assert (and tcl-chan
                            (not (cffi:null-pointer-p tcl-chan)))
                       (tcl-chan))))
           ;;
           (regist-tcl-chan (interp chan)
             (with-slots (tcl-chan) chan
               (assert chan (chan) "Not Tcl_CreateChannel'd (~a)" chan)
               (tcl-register-channel interp tcl-chan)))
           ;;
           (replace-tcl-std-chan (interp chan tcl-std-chan-type)
             (tcl-set-std-channel (cffi:null-pointer) tcl-std-chan-type)
             (let ((old-tcl-chan (tcl-get-std-channel tcl-std-chan-type)))
               (unless (cffi:null-pointer-p old-tcl-chan)
                 (tcl-unregister-channel interp old-tcl-chan)))
             (with-slots (tcl-chan (tcl-std-chan-type* tcl-std-chan-type)) chan
               (regist-tcl-chan interp chan) ; <-- 절차가 중요했다.
               (tcl-set-std-channel tcl-chan tcl-std-chan-type)
               (setf tcl-std-chan-type* tcl-std-chan-type)))
           ;;
           (set-chan-opts (interp chan)
             (with-slots (tcl-chan) chan
               (tcl-set-channel-option interp tcl-chan "-translation" "binary")
               (tcl-set-channel-option interp tcl-chan "-encoding" "utf-8")
               (tcl-set-channel-option interp tcl-chan "-bufferin" "none"))))
    ;;
    (%put-instance chan)
    (create-tcl-chan chan)
    (if tcl-std-chan-type
        (replace-tcl-std-chan tcl-interp-ptr chan tcl-std-chan-type)
        ;; else:
        (regist-tcl-chan tcl-interp-ptr chan))
    (set-chan-opts tcl-interp-ptr chan)))



(defmethod unregist
    ((chan <redir-to-outstream-chan>)
     &key
       tcl-interp-ptr)
  (with-slots (tcl-chan tcl-std-chan-type) chan
    (assert tcl-chan)
    (if tcl-std-chan-type
        (progn
          (tcl-unregister-channel tcl-interp-ptr tcl-chan)
          (tcl-set-std-channel (cffi:null-pointer) tcl-std-chan-type))
        ;; else:
        (tcl-unregister-channel tcl-interp-ptr tcl-chan))
    ;;
    (%rem-instance chan)))








