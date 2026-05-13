
(defpackage #:tclish/examples/05-tk-main-loop
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-tk-main-loop))

(in-package :tclish/examples/05-tk-main-loop)


(defun main-tk-main-loop ()
  (app-main (:tk-init? t :tk-main-loop? t)
            (eval-str "button .btn -text {<esc>:q!} -command {destroy .}"
                      "pack .btn")))
