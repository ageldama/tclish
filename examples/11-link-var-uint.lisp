(defpackage #:tclish/examples/11-link-var-uint
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/11-link-var-uint)


(defun main ()
  (app-main ()
            (def-cmd/p)

            (eval-tcl "set xxx 0")

            (let ((xxx (make-instance '<tcl-var-link>
                                      :var-type +tcl-link-uint+
                                      :tcl-name "xxx"
                                      :initial-element 42)))
              (unwind-protect
                   (progn
                     (eval-tcl "p $xxx")

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
