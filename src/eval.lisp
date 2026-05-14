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
      (cond
        ((listp cmd) (case (first cmd)
                       (:tcl-string (eval-tcl/tcl-string (second cmd)))
                       (:tcl-objv   (eval-tcl/tcl-objv (third cmd) (second cmd)))
                       (t           (eval-tcl/tcl-obj-list cmd))))
        (t (eval-tcl/str cmd))))
    (result-as result-as)))


(defun eval-tcl/str (cmd)
  (do+chk (tcl-eval) *tcl-interp* cmd))


(defun eval-tcl/tcl-obj-list (cmd-list)
  "(list Tcl_Obj*)"
  (with-tcl-objv (cmd-list)
    (eval-tcl/tcl-objv tcl-objv tcl-objc)))


(defun eval-tcl/tcl-string (cmd)
  ":tcl-string (Tcl_Obj*)"
  (do+chk (tcl-eval-obj) *tcl-interp* cmd))


(defun eval-tcl/tcl-objv (objv objc)
  ":tcl-objv (obj-count  Tcl_Obj**)"
  (do+chk (tcl-eval-objv) *tcl-interp* objc objv 0))



(defun result-as (result-as)
  (case result-as
    (:string (tcl-get-string-result *tcl-interp*))
    (:obj    (tcl-get-obj-result *tcl-interp*))
    (t       nil)))


