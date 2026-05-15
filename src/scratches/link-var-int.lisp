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

            (let ((xxx (make-instance '<tcl-var-link>
                                      :var-type +tcl-link-uint+
                                      :tcl-name "xxx")))
              (unwind-protect
                   (progn
                     (eval-tcl "set xxx 18")
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx")

                     (eval-tcl "set xxx 28")
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx")

                     (setf (linked-value xxx) 39)
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx"))

                ;; cleanup:
                (destroy xxx)))))
