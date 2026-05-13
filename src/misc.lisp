(in-package :tclish)




(defun cmd/p (interp &key (cmd-name "p"))
  (create-command
      (cmd-name :interp interp)
      (format t "~{~A~}~%" (cdr tclish:args))))


