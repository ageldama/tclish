(in-package :tclish)

(defun eval-tcl (&rest cmds)
  (assert (and *tcl-interp*
               (not (cffi:null-pointer-p *tcl-interp*)))
          (*tcl-interp*))
  ;;
  (let* ((result-as :string)
         (cmds* (iter (generating gel in cmds)
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
    (dolist (cmd cmds*)
      (do+chk (tcl-eval) *tcl-interp* cmd))
    (result-as result-as)))


(defun result-as (result-as)
  (case result-as
    (:string (tcl-get-string-result *tcl-interp*))
    (:obj    (tcl-get-obj-result *tcl-interp*))
    (t       nil)))



;; TODO (list Tcl_Obj*) => ... => tcl-eval-objv
;; TODO :tcl-string Tcl_Obj*        => tcl-eval-obj-ex
;; TODO :tcl-objv   [obj-count]  Tcl_Obj**       => tcl-eval-objv
