
(defpackage #:tclish/example/01-tk-msgbox
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-tk-msg-box))

(in-package :tclish/example/01-tk-msgbox)


(defun main-tk-msg-box ()
  (let ((interp (tcl-create-interp)))
    (unwind-protect
         (let ((*tcl-interp* interp) (*do+chk/error?* t))
           (do+chk (tcl-init) interp)
           (do+chk (tk-init) interp)
           (do+chk (tcl-eval)
                   interp "tk_messageBox -message {안녕하슈! Hello!}"))
      ;; cleanup:
      (tcl-delete-interp interp))))
