
(defpackage #:tclish/examples/01-tk-msgbox
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-tk-msg-box))

(in-package :tclish/examples/01-tk-msgbox)


(defun main-tk-msg-box ()
  (app-main (:tk-init? t
             :tk-main-loop? nil
             :after-init (format t "here we go~%"))
            (eval-str "tk_messageBox -message {안녕하슈! Hello!}")))


