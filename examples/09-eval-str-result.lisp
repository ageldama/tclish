
(defpackage #:tclish/examples/09-eval-str-result
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/09-eval-str-result)


(defun main ()
  (app-main ()
            (def-cmd ("ret_sth") "CANI?STR?")
            (format t "RESULT=[~A]~%"
                    ;; :result-as could be one of (nil :string :obj).
                    (eval-str :result-as :string "ret_sth"))))

