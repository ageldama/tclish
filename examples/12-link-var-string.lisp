(defpackage  #:tclish/examples/12-link-var-string
  (:use #:cl #:tclish #:raw-cffi-tcl9)
  (:export :main))

(in-package :tclish/examples/12-link-var-string)

(defun main ()
  (app-main ()
            (def-cmd/p)

            (eval-tcl "set xxx {foobar}")

            (let ((xxx (make-instance '<tcl-var-link>
                                      :var-type +tcl-link-string+
                                      :tcl-name "xxx"
                                      :initial-element "HOWDY?!"
                                      )))
              (format t "VAR-LINK: ~a~%" xxx)
              (unwind-protect
                   (progn
                     (eval-tcl "p $xxx")

                     (eval-tcl "set xxx {foo}")
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx")

                     (eval-tcl "set xxx {bar}")
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx")

                     (setf (linked-value xxx) "quux")
                     (format t "[~a]~%" (linked-value xxx))
                     (eval-tcl "p $xxx"))

                ;; cleanup:
                (destroy xxx)
                ))))
