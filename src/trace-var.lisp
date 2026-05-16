(in-package #:tclish)


(def-tcl-callback-pattern
    :cb-prefix "trace-var"
  :one-off? nil
  :counter-cffi-type :uint32)


(cffi:defcallback %trace-var-proc-cb-cfunc (:pointer :char)
    ((client-data  :pointer)
     (interp       tcl-interp-ptr)
     (part1        :string)
     (part2        :string)
     (flags        :int))
  (handler-case
      (progn
        (trace-var/route-by-client-data client-data
                                        :client-data client-data
                                        :interp      interp
                                        :part1       part1
                                        :part2       part2
                                        :flags       flags)
        ;;
        (when (flags-bit? +tcl-trace-destroyed+ flags)
          (trace-var/unregist-cb client-data))
        ;;
        (cffi:null-pointer))
    (error (c)
      ;; Under normal conditions trace procedures should return NULL,
      ;; indicating successful completion. If proc returns a non-NULL
      ;; value it signifies that an error occurred. The return value
      ;; must be a pointer to a static character string containing an
      ;; error message, unless (exactly one of) the
      ;; TCL_TRACE_RESULT_DYNAMIC and TCL_TRACE_RESULT_OBJECT flags is
      ;; set,
      (cffi:with-foreign-string (err-msg-ptr (format nil "~a" c))
        (let ((err-msg-obj-ptr (tcl-new-string-obj err-msg-ptr -1)))
          (tcl-incr-ref-count err-msg-obj-ptr)
          err-msg-obj-ptr)))))


(defun trace-var/enforce-flags (flags)
  (logior flags +tcl-trace-result-object+ +tcl-trace-unsets+))


(defun trace-var/+trace (var-name
                         closure
                         &key (flags 0)
                           array-subs)
  (let* ((registration (trace-var/regist-cb closure))
         (client-data  (getf registration :client-data))
         (flags*       (trace-var/enforce-flags flags)))
    (do+chk (tcl-trace-var2)
            *tcl-interp*
            var-name
            (lisp-value-or-nullptr array-subs)
            flags*
            (cffi:callback %trace-var-proc-cb-cfunc)
            client-data)
    client-data))


(defun trace-var/-untrace (var-name
                           client-data
                           &key (flags 0)
                             array-subs)
  (let ((flags*       (trace-var/enforce-flags flags)))
    (tcl-untrace-var2 *tcl-interp* var-name
                      (lisp-value-or-nullptr array-subs)
                      flags*
                      (cffi:callback %trace-var-proc-cb-cfunc)
                      client-data)))


(defun trace-var/list-all (var-name
                           &key
                             array-subs)
  (iter (with prev-client-data = (cffi:null-pointer))
    (for client-data = (tcl-var-trace-info2 *tcl-interp*
                                            var-name
                                            (lisp-value-or-nullptr array-subs)
                                            0 ;; =flags
                                            (cffi:callback %trace-var-proc-cb-cfunc)
                                            prev-client-data))
    (if (cffi:null-pointer-p client-data)
        (terminate)
        (collect client-data))
    (setf prev-client-data client-data)))




(defclass <tcl-var-trace> ()
  ((var-name :reader var-name
             :initarg :var-name)
   (array-subs :reader array-subs
               :initarg :array-subs
               :initform nil)
   (flags      :reader flags
               :initarg :flags
               :initform 0)
   (cb-closure    :reader cb-closure
                  :initarg :cb-closure)
   (client-data :reader client-data
                :initform nil)))

(defmethod print-object ((var-trace <tcl-var-trace>) stream)
  (print-unreadable-object (var-trace stream :type t :identity t)
    (format stream
            "var-name:~a  array-subs:~a  flags:~a  cb-closure:~a  client-data:~a"
            (var-name var-trace)
            (array-subs var-trace)
            (flags var-trace)
            (cb-closure var-trace)
            (client-data var-trace))))

(defmethod initialize-instance :before
    ((var-trace <tcl-var-trace>) &rest args)
  (assert (member :var-name args) (args))
  (assert (member :cb-closure args) (args))
  (assert (not (member :client-data args)) (args)))

(defmethod initialize-instance :after
    ((var-trace <tcl-var-trace>) &key)
  (with-slots (client-data) var-trace
    (setf client-data
          (trace-var/+trace (var-name var-trace)
                            (cb-closure var-trace)
                            :array-subs (array-subs var-trace)
                            :flags (flags var-trace)))))

(defmethod untrace-var ((var-trace <tcl-var-trace>))
  (trace-var/-untrace
   (var-name var-trace)
   (client-data var-trace)
   :flags (flags var-trace)))




