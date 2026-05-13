
(defpackage #:tclish/examples/02-def-cmd
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-def-cmd))

(in-package :tclish/examples/02-def-cmd)


(defun main-def-cmd ()
  (app-main ()

            ;; body:
            (def-cmd ("p")
                     (format t "~{~A~}~%" (cdr args)))

            (def-cmd ("do_sth_1")
                     (format t "STH-1: ~a~%" interp)
                     :sth-1-done)

            (def-cmd ("do_sth_err")
                     (format t "STH-ERR: ~a~%" interp)
                     (error "err!err!")
                     :sth-err-done)

            ;;
            (do+chk (tcl-eval :error? nil)
                    *tcl-interp*
                    "p [do_sth_1]; p [do_sth_err]")))

