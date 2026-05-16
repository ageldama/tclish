(defpackage #:tclish/examples/15-trace-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/15-trace-var)


(defun main ()
  (app-main
      ()

      (let* ((touched '())
             (touch (lambda (name)
                      (setf touched (append touched (list name)))))
             (tracer-1  (trace-var/+trace "xxx"
                                          (lambda (&rest args)
                                            (declare (ignorable args))
                                            (funcall touch :tracer-1))
                                          :flags
                                          (->flags-bits* +tcl-trace-writes+)))
             (tracer-2  (trace-var/+trace "xxx"
                                          (lambda (&rest args)
                                            (declare (ignorable args))
                                            (funcall touch :tracer-2))
                                          :flags
                                          (->flags-bits* +tcl-trace-writes+))))

        (format t "LIST-TRACERS #1: ~a~%" (trace-var/list-all "xxx"))

        (eval-tcl "set xxx 42")
        (format t "TRACED #1: ~a~%" touched)

        ;; TCL_TRACE_DESTROYED = YES.
        (trace-var/-untrace "xxx" tracer-2
                            :flags (->flags-bits* +tcl-trace-writes+))

        (eval-tcl "set xxx 421")
        (format t "TRACED #2: ~a~%" touched)

        (format t "LIST-TRACERS #2: ~a~%" (trace-var/list-all "xxx"))

        (eval-tcl "unset xxx")
        (format t "TRACED #3: ~a~%" touched) ;; TCL_TRACE_DESTROYED = NO.

        (trace-var/-untrace "xxx" tracer-1
                            :flags (->flags-bits* +tcl-trace-writes+))

        (format t "LIST-TRACERS #3: ~a~%" (trace-var/list-all "xxx"))

        (eval-tcl "set xxx 11111")
        (format t "TRACED #4: ~a~%" touched) ;; NO CHANGES


        )))


