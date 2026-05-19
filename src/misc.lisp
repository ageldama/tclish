(in-package :tclish)




(defun def-cmd/p (&key (cmd-name "p"))
  "Defines `CMD-NAME`=`p` Tcl command.

Which simply pretty-prints arguments as Tcl strings to
`*STANDARD-OUTPUT*`."
  (def-cmd (cmd-name :interp *tcl-interp*)
           (format t "~{~W~}~%" (cdr tclish:args))))


