(in-package :tclish)



(defmacro with-interp (interp &rest body)
  `(let ((*tcl-interp* ,interp))
     ,@body))


(defun interp/deleted? ()
  (<-tcl-int-bool (tcl-interp-deleted *tcl-interp*)))

(defun interp/active? ()
  (<-tcl-int-bool (tcl-interp-active *tcl-interp*)))

(defun interp/safe? ()
  (<-tcl-int-bool (tcl-is-safe *tcl-interp*)))

(defun interp/child (child-name)
  (let ((child-interp (tcl-get-child *tcl-interp* child-name)))
    (if (cffi:null-pointer-p child-interp)
        (tcl-result-as-error)
        child-interp)))

(defun interp/parent ()
  (nullptr->nil (tcl-get-parent *tcl-interp*)))

(defun interp/create-child (child-name safe?)
  (tcl-create-child *tcl-interp* child-name
                    (lisp-bool->c-int safe?)))

(defun interp/interp-path (child-interp)
  (do+chk (tcl-get-interp-path) *tcl-interp* child-interp)
  (tcl-get-string-result *tcl-interp*))

(defun interp/expose-cmd (hidden-cmd-name cmd-name)
  (do+chk (tcl-expose-command) *tcl-interp* hidden-cmd-name cmd-name))

(defun interp/hide-cmd (cmd-name hidden-cmd-name)
  (do+chk (tcl-hide-command) *tcl-interp* cmd-name hidden-cmd-name))
