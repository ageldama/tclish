(defpackage #:tclish/examples/17-interp-trace
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/17-interp-trace)



(defun mk-tracer (tag)
  (lambda
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
                     (format t "~a }} TRACER [~a] {{~T~TCMD=\"~a\" (~A)~%"
                             (lvl-hdr level) tag command-name
                             (tclish::cmd-info/full-name command-obj)
                             ))
      )))



(defun main ()
  (app-main
      (:terminate-without-deinit t)

      (def-cmd/p)
      (eval-tcl "proc f {} {p F; g}")
      (eval-tcl "proc g {} {p G}")

      (let* ((tracer-enter  (interp-trace/+trace
                             (mk-tracer "ENTER")
                             :flags
                             (->flags-bits*
                              +tcl-allow-inline-compilation+
                              +tcl-trace-enter-exec+)))
             (tracer-leave  (interp-trace/+trace
                             (mk-tracer "LEAVE")
                             :flags
                             (->flags-bits*
                              +tcl-allow-inline-compilation+
                              +tcl-trace-leave-exec+))))

        (eval-tcl "f")

        (interp-trace/-delete tracer-enter)
        (interp-trace/-delete tracer-leave)

        (format t "~80<~;--- TRACERS REMOVED ---~;~>~%")

        (eval-tcl "f")
        )))


