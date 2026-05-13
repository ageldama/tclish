
(defpackage #:tclish/examples/05-tk-main-loop
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-tk-main-loop))

(in-package :tclish/examples/05-tk-main-loop)


(defun main-tk-main-loop ()
  (app-main (:tk-init? t :tk-main-loop? t)
            (do+chk (tcl-eval)
                    *tcl-interp*
                   (concatenate 'string
                                "button .btn -text {<esc>:q!} -command {destroy .};"
                                "pack .btn"))))
