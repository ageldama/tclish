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
  (logior flags +tcl-trace-result-object+))


(defun trace-var/+trace (var-name
                         closure
                         &key flags
                           array-subs)
  (let* ((registration (trace-var/regist-cb closure))
         (client-data  (getf registration :client-data))
         (flags*       (trace-var/enforce-flags flags)))
    (do+chk (tcl-trace-var2)
            *tcl-interp* var-name array-subs flags*
            (cffi:callback %trace-var-proc-cb-cfunc)
            client-data)
    client-data))


(defun trace-var/-untrace (var-name
                           client-data
                           &key flags
                             array-subs)
  (let ((flags*       (trace-var/enforce-flags flags)))
    (tcl-untrace-var2 *tcl-interp* var-name array-subs flags*
                      (cffi:callback %trace-var-proc-cb-cfunc)
                      client-data)))




;; TODO var-info

