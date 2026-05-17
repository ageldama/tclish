(defpackage #:tclish/examples/17-interp-trace
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/17-interp-trace)



(defun tracer-1-func
    (&rest args
     &key
       client-data level
       command-name command-obj objc objv)
  (declare (ignorable args client-data
                      level command-name command-obj objc objv))

  (labels ((lvl-hdr (n &key (stream nil) (ch "-"))
             (format stream "~v@{~A~:*~}" n ch)))

    (with-cmd-info (:v-cmd-info cmd-info :cmd-obj command-obj
                    :modify? nil)
                   (format t "~a }} TRACER #1 {{~T~TCMD=\"~a\" (~A)~%"
                           (lvl-hdr level) command-name
                           (tclish::cmd-info/full-name command-obj)
                           ))
    ))



(defun main ()
  (app-main
      (:terminate-without-deinit t)

      (def-cmd/p)
      (eval-tcl "proc f {} {p F; g}")
      (eval-tcl "proc g {} {p G}")

      (let* ((tracer-1  (interp-trace/+trace #'tracer-1-func)))

        (eval-tcl "f")

        (interp-trace/-delete tracer-1)

        (format t "~80<~;--- TRACERS REMOVED ---~;~>~%")

        (eval-tcl "f")
        )))


