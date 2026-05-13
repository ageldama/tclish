(in-package :tclish)

(defun eval-str (&rest strs)
  (dolist (s strs)
    (do+chk (tcl-eval) *tcl-interp* s)))

