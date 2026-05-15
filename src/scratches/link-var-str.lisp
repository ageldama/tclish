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

            (eval-tcl "set xxx {foobar spameggs}")
            ;;(eval-tcl "p [set xxx]")

            (let ((xxx
                    (link/+var "xxx" +tcl-link-string+
                               :initial-element "fooo"
                               )))

              ;;(link/update "xxx")

              (eval-tcl "set xxx {quux frob}")
              (format t "[~a]~%"
                      (link/access-var xxx +tcl-link-string+))

              (eval-tcl "p [set xxx]")

              (link/free-var xxx +tcl-link-string+)


            )))
