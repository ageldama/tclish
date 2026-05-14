(in-package :tclish)




(defun def-cmd/p (&key (cmd-name "p"))
  (def-cmd (cmd-name :interp *tcl-interp*)
           (format t "~{~A~}~%" (cdr tclish:args))))


