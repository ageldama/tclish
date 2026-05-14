(in-package :tclish)

(defun apply-lambda
    (tcl-lambda args
     &key (result-as :string))
  (with-tcl-objv
      (`("apply" ,tcl-lambda ,@args))
      (progn
        (do+chk (tcl-eval-objv) *tcl-interp* tcl-objc tcl-objv 0)
        (result-as result-as))))


