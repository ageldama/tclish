(defpackage #:tclish/examples/17-interp-trace
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/17-interp-trace)



(defun tracer-1-func
    (&rest args
     &key
       client-data level command command-info objc objv
       )
  (declare (ignorable args client-data
                      level command command-info objc objv))

  (labels ((lvl-hdr (n &key (stream nil) (ch "-"))
             (format stream "~v@{~A~:*~}" n ch)))

    (format t "~a }} TRACER #1 {{~T~TCMD=\"~a\"~%"
            (lvl-hdr level) command)
  ))



(defun main ()
  (app-main
      ()

      (def-cmd/p)
      (eval-tcl "proc f {} {p F; g}")
      (eval-tcl "proc g {} {p G}")

      (let* ((tracer-1  (interp-trace/+trace #'tracer-1-func)))

        (eval-tcl "f")

        (interp-trace/-delete tracer-1)

        (format t "~80<~;--- TRACERS REMOVED ---~;~>~%")

        (eval-tcl "f")
        )))


