
(defpackage #:tclish/examples/02-def-cmd
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-def-cmd))

(in-package :tclish/examples/02-def-cmd)


(defun main-def-cmd ()
  (app-main (:do+chk/error? nil)
            ;; body:
            (def-cmd ("cmd_1")
                     (format t "CMD-1: ~a~%" interp)
                     :cmd-1-done)

            (def-cmd ("cmd_err")
                     (format t "CMD-ERR: ~a~%" interp)
                     (error "err!err!")
                     :cmd-err-done)

            (def-cmd ("p")
                     (format t "~{~A~}~%" (cdr args)))

            ;;
            (eval-str "p [cmd_1]"
                      "p [cmd_err]")))

