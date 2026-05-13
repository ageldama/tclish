(in-package :tclish)


(defun tcl-ns (ns-fqn
                  &key
                    exports
                    (interp *tcl-interp*))
    (let ((ns-ptr (raw-cffi-tcl9:tcl-create-namespace
                   interp ns-fqn (cffi:null-pointer) (cffi:null-pointer))))
      ;; 이미 존재한다면:
      (when (cffi:null-pointer-p ns-ptr)
        (setf ns-ptr
              (raw-cffi-tcl9:tcl-find-namespace interp ns-fqn
                                                (cffi:null-pointer) 0))
        (assert (not (cffi:null-pointer-p ns-ptr)) (ns-ptr)))
      ;;
      (dolist (exp exports)
        (raw-cffi-tcl9:tcl-export interp ns-ptr exp 0))
      ;;
      ns-ptr))

