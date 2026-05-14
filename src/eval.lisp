(in-package :tclish)

(defun eval-tcl (&rest strs)
  (assert (and *tcl-interp*
               (not (cffi:null-pointer-p *tcl-interp*)))
          (*tcl-interp*))
  ;;
  (let* ((result-as :string)
         (strs* (iter (generating gel in strs)
                  (for el = (next gel))
                  (case el
                    (:result-as
                     (progn
                       (setf result-as (next gel))
                       (assert (or (null result-as)
                                   (member result-as '(:obj :string)))
                               (result-as))))
                    (t          (collect el))))))
    ;;
    (dolist (s strs*)
      (do+chk (tcl-eval) *tcl-interp* s))
    (case result-as
      (:string (tcl-get-string-result *tcl-interp*))
      (:obj    (tcl-get-obj-result *tcl-interp*))
      (t       nil))))


