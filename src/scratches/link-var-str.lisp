(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :cffi)
  (ql:quickload :tclish))

(defpackage #:scratch-link-var-str
  (:use #:cl #:tclish #:raw-cffi-tcl9)
  (:export :main))


(in-package :scratch-link-var-str)


(defun main ()
  (app-main ()
            (def-cmd/p)

            ;; (eval-tcl "set xxx {foobar spameggs}")
            ;; (eval-tcl "p [set xxx]")

            (let ((xxx
                    (link/+var "xxx" +tcl-link-string+
                               ;;:initial-element ""
                               )))

              ;;(link/update "xxx")

              ;;(format t "[~a]~%" (cffi:foreign-string-to-lisp xxx))

              ;;(eval-tcl "p [set xxx]")

              (link/free-var xxx +tcl-link-string+)


            )))
