(in-package :tclish)


(defun create-ns (ns-fqn
                  &key
                    exports
                    (interp *tcl-interp*))
    (let ((ns-ptr (raw-cffi-tcl9:tcl-create-namespace
                   interp ns-fqn (cffi:null-pointer) (cffi:null-pointer))))
      (dolist (exp exports)
        (raw-cffi-tcl9:tcl-export interp ns-ptr exp 0))
      ns-ptr))

