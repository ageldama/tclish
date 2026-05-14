(in-package :tclish)



(defmacro with-interp (interp &rest body)
  `(let ((*tcl-interp* ,interp))
     ,@body))


(defun interp-deleted? ()
  (not (zerop (tcl-interp-deleted *tcl-interp*))))

(defun interp-active? ()
  (not (zerop (tcl-interp-active *tcl-interp*))))
