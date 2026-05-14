
(defpackage #:tclish/examples/10-tcl-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/10-tcl-var)


(defun main ()
  (macrolet ((it-is-okay-to-error (&rest body)
               (let ((%erred (gensym)))
                 `(let ((,%erred nil))
                    (handler-case (progn ,@body)
                      (error (c) (setf ,%erred c)
                        (format t "OK = ERR-CAUGHT: ~a~%" c)))
                    (assert ,%erred (,%erred)
                            "Supposed to raise error, but wasn't!")))))
    ;;
    (app-main (:do+chk/error? t)
              ;; Getting error on reading non-existing variable:
              (it-is-okay-to-error (tcl-var "unknownxxx"))

              (it-is-okay-to-error (tcl-var "unknownxxx" :as :obj))

              ;; get/set simple variables:
              (setf (tcl-var "foo") "bar"
                    (tcl-var "fruits") "{apple banana pineapple}")
              (format t "FRUITS: ~a~%" (tcl-var "fruits"))

              ;; unset-var
              (unset-var "foo")
              (it-is-okay-to-error (tcl-var "foo"))

              (it-is-okay-to-error (unset-var "unknownxxx"))

              ;; namespace:
              (let ((cities "{seoul gwangju wonju gangreung paju goyang}"))

                ;; this should fail:
                (it-is-okay-to-error (setf (tcl-var "::myns::cities") cities))

                ;; namespace, try again:
                (tcl-ns "::myns")
                (setf (tcl-var "::myns::cities") cities))

              (format t "cities (finally): ~a ~a~%"
                      (eval-tcl "info vars ::myns::*")
                      (tcl-var "::myns::cities")))))

