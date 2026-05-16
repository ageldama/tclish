(defpackage #:tclish/examples/17-interp-trace
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/17-interp-trace)



(defun main ()
  (app-main
      ()

      (def-cmd/p)
      (eval-tcl "proc f {} {p F; g}")
      (eval-tcl "proc g {} {p G}")

      (let* ((tracer-1  (interp-trace/+trace
                         (lambda (&rest args)
                           (format t "TRACER-1: ~a~%" args))))

             (tracer-2  (interp-trace/+trace
                         (lambda (&rest args)
                           (format t "TRACER-2: ~a~%" args))
                         :flags (->flags-bits* +tcl-trace-leave-exec+))))

        (eval-tcl "f")

        (interp-trace/-delete tracer-2)

        (eval-tcl "f")
        )))


