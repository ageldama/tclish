
(defpackage #:tclish/examples/02-create-command
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-create-command))

(in-package :tclish/examples/02-create-command)


(defun main-create-command ()
  (app-main ()

            ;; body:
            (create-command ("p")
                            (format t "~{~A~}~%" (cdr args)))

            (create-command ("do_sth_1")
                            (format t "STH-1: ~a~%" interp)
                            :sth-1-done)

            (create-command ("do_sth_err")
                            (format t "STH-ERR: ~a~%" interp)
                            (error "err!err!")
                            :sth-err-done)

            ;;
            (do+chk (tcl-eval :error? nil)
                    *tcl-interp*
                    "p [do_sth_1]; p [do_sth_err]")))

