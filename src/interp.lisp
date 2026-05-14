(in-package :tclish)



(defmacro with-interp (interp &rest body)
  `(let ((*tcl-interp* ,interp))
     ,@body))


(defun interp/deleted? ()
  (not (zerop (tcl-interp-deleted *tcl-interp*))))

(defun interp/active? ()
  (not (zerop (tcl-interp-active *tcl-interp*))))

(defun interp/safe? ()
  (not (zerop (tcl-is-safe *tcl-interp*))))

(defun interp/child (child-name)
  (let ((child-interp (tcl-get-child *tcl-interp* child-name)))
    (if (cffi:null-pointer-p child-interp)
        nil ;; TODO
        child-interp)))

(defun interp/parent ()
  (nullptr->nil (tcl-get-parent *tcl-interp*)))

(defun interp/create-child (child-name safe?)
  (tcl-create-child *tcl-interp* child-name
                    (lisp-bool->c-int safe?)))

(defun interp/interp-path (child-interp)
  (do+chk (tcl-get-interp-path) *tcl-interp* child-interp)
  (tcl-get-string-result *tcl-interp*))




#|


       int
       Tcl_CreateAlias(childInterp, childCmd, targetInterp, targetCmd,
                       argc, argv)

       int
       Tcl_CreateAliasObj(childInterp, childCmd, targetInterp, targetCmd,
                          objc, objv)

       int
       Tcl_GetAliasObj(interp, childCmd, targetInterpPtr, targetCmdPtr,
                       objcPtr, objvPtr)

       int
       Tcl_ExposeCommand(interp, hiddenCmdName, cmdName)

       int
       Tcl_HideCommand(interp, cmdName, hiddenCmdName)

|#
