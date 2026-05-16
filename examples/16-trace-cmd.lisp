(defpackage #:tclish/examples/16-trace-cmd
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/16-trace-cmd)



;;; NOTE Tcl_UntraceCommand seems broken somehow?
;;;
;;;      Probably I'm doing something wrong, stupidly.

(defun main ()
  (app-main
      ()

      (eval-tcl "proc xxx {} {}")

      (let* ((tracer-1  (make-instance '<tcl-cmd-trace>
                                       :cmd-name "xxx"
                                       :cb-closure
                                       (lambda (&rest args)
                                         (format t "TRACE-1: ~a~%" args))
                                       :flags
                                       (->flags-bits* +tcl-trace-rename+)))
             (tracer-2  (make-instance '<tcl-cmd-trace>
                                       :cmd-name "xxx"
                                       :cb-closure
                                       (lambda (&rest args)
                                         (format t "TRACE-2: ~a~%" args))
                                       :flags
                                       (->flags-bits* +tcl-trace-rename+))))

        (format t "LIST-TRACERS #1: ~a~%" (trace-cmd/list-all "xxx"))
        (eval-tcl "rename xxx yyy")

        ;; TCL_TRACE_DESTROYED = YES.
        (untrace-cmd tracer-2)

        (eval-tcl "rename yyy xxx")

        (format t "BYE~%")
        ;;(eval-tcl "rename yyy xxx")

        )))


