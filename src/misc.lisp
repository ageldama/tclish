(in-package :tclish)




(defun cmd/p (interp &key (cmd-name "p"))
  (create-command
      (:interp interp :name cmd-name)
      (format t "~{~A~}~%" (cdr tclish:args))))


