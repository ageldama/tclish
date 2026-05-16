(defpackage #:tclish/examples/15-trace-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/15-trace-var)


(defun main ()
  (app-main
      ()

      (let* ((touched '())
             (tracer-1  (trace-var/+trace "xxx"
                                          (lambda (&rest args)
                                            (declare (ignorable args))
                                            (alexandria:nconcf touched
                                                               '(:tracer-1)))
                                          :flags
                                          (->flags-bits* +tcl-trace-writes+)))
             (tracer-2  (trace-var/+trace "xxx"
                                          (lambda (&rest args)
                                            (declare (ignorable args))
                                            (alexandria:nconcf touched
                                                               '(:tracer-2)))
                                          :flags
                                          (->flags-bits* +tcl-trace-writes+))))

        (eval-tcl "set xxx 42")
        (format t "TRACED #1: ~a~%" touched)

        ;; (trace-var/-untrace "xxx" tracer-2)
        (eval-tcl "set xxx 421")
        (format t "TRACED #2: ~a~%" touched)


        )))


