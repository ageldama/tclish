
(defpackage #:tclish/examples/10-tcl-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/10-tcl-var)


(defun main ()
  (app-main ()
            ;; Getting error on reading non-existing variable:
            (let ((*do+chk/error?* t))
              (handler-case (tcl-var "unknownxxx")
                (error (c) (format t "OK = ERR-CAUGHT: ~a~%" c)))

              (handler-case (tcl-var "unknownxxx" :as :obj)
                (error (c) (format t "OK = ERR-CAUGHT: ~a~%" c))))

            ;; get/set simple variables:
            (setf (tcl-var "foo") "bar"
                  (tcl-var "fruits") "{apple banana pineapple}")
            (format t "FRUITS: ~a~%" (tcl-var "fruits"))

            ;; namespace:
            (let ((cities "{seoul gwangju wonju gangreung paju goyang}"))

              ;; this should fail:
              (handler-case (setf (tcl-var "::myns::cities") cities)
                (error (c) (format t "OK = ERR-CAUGHT: ~a~%" c)))

              ;; namespace, try again:
              (tcl-ns "::myns")
              (setf (tcl-var "::myns::cities") cities))

            (format t "cities (finally): ~a ~a~%"
                    (eval-tcl "info vars ::myns::*")
                    (tcl-var "::myns::cities"))))

