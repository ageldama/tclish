(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :cffi)
  (ql:quickload :tclish))

(defpackage #:scratch-link-var-int
  (:use #:cl #:tclish #:raw-cffi-tcl9)
  (:export :main))


(in-package :scratch-link-var-int)


(defun main ()
  (app-main ()
            (def-cmd/p)

             (eval-tcl "set xxx 42")
            ;; (eval-tcl "p [set xxx]")

            (let ((xxx
                    (link/+var "xxx" +tcl-link-int+
                               ;:initial-element 18
                               )))

              ;;(link/update "xxx")

              (eval-tcl "set xxx 18")

              (format t "[~a]~%"
                      (tclish:link/access-var
                       xxx
                       raw-cffi-tcl9:+tcl-link-int+))

              (eval-tcl "p $xxx")

              (link/free-var xxx +tcl-link-int+)


            )))
