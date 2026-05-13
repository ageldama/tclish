
(defpackage #:tclish/examples/05-tk-main-loop
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-tk-main-loop))

(in-package :tclish/examples/05-tk-main-loop)


(defun main-tk-main-loop ()
  (let ((interp (tcl-create-interp)))
    (unwind-protect
         (let ((*tcl-interp* interp) (*do+chk/error?* t))
           (do+chk (tcl-init) interp)
           (do+chk (tk-init) interp)
           (do+chk (tcl-eval)
                   interp
                   (concatenate 'string
                                "button .btn -text {<esc>:q!} -command {destroy .};"
                                "pack .btn"
                                )))
      (tk-main-loop)
      ;; cleanup:
      (tcl-delete-interp interp))))
