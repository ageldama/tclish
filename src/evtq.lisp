(in-package :tclish)



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



