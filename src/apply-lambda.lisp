(in-package :tclish)

(defun apply-lambda
    (tcl-lambda args
     &key (result-as :string))
  "Apply `ARGS` on Tcl lambda-list (`TCL-LAMBDA`): https://www.tcl-lang.org/man/tcl/TclCmd/apply.html

`:RESULT` keyword parameter is `(MEMBER (:STRING :OBJ)` (See
`RESULT-AS`)"
  (with-tcl-objv
      (`("apply" ,tcl-lambda ,@args))
      (progn
        (do+chk (tcl-eval-objv) *tcl-interp* tcl-objc tcl-objv 0)
        (result-as result-as))))


