
(defpackage #:tclish/examples/08-apply-lambda
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-apply-lambda))

(in-package :tclish/examples/08-apply-lambda)


(defun main-apply-lambda ()
  (app-main ()
            (def-cmd/p)

            (def-cmd ("gimme_lambda")
                     (let ((lambda-list  (second tclish:args))
                           (lambda-args  (cddr   tclish:args)))
                       (apply-lambda tclish:interp
                                     lambda-list
                                     lambda-args)))

            ;;
            (eval-str "p [gimme_lambda {{x y} {expr $x ** $y}} 3 4]")))

