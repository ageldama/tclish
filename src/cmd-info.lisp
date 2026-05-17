(in-package :tclish)


(defun tcl-command/full-name (cmd)
  (let ((result (tcl-new-obj))) ;; refcnt=0
    (unwind-protect
         (progn
           (tcl-incr-ref-count result) ;; refcnt++
           (tcl-get-command-full-name *tcl-interp* cmd result)
           (cffi:foreign-string-to-lisp
            (tcl-get-string-from-obj result (cffi:null-pointer))))
      ;; cleanup:
      (tcl-decr-ref-count result) ;; refcnt-- == 0.
      )))





#|


(defcfun ("Tcl_GetCommandFullName" tcl-get-command-full-name) :void
  "/* 517 */ EXTERN void
Tcl_GetCommandFullName(Tcl_Interp *interp, Tcl_Command command, Tcl_Obj *objPtr);"
  (interp-ptr     tcl-interp-ptr)
  (command        tcl-command)
  (obj-ptr        tcl-obj-ptr))



(defcfun ("Tcl_GetCommandName" tcl-get-command-name) :string
  "/* 160 */ EXTERN const char *
Tcl_GetCommandName(Tcl_Interp *interp, Tcl_Command command);"
  (interp-ptr tcl-interp-ptr)
  (command    tcl-command))


(defcfun ("Tcl_GetCommandInfoFromToken" tcl-get-command-info-from-token) :int
  "/* 484 */ EXTERN int
Tcl_GetCommandInfoFromToken(Tcl_Command token, Tcl_CmdInfo *infoPtr);"
  (token         tcl-command)
  (cmd-info-ptr  tcl-cmd-info-ptr))

(defcfun ("Tcl_SetCommandInfoFromToken" tcl-set-command-info-from-token) :int
  "/* 485 */ EXTERN int
Tcl_SetCommandInfoFromToken(Tcl_Command token, const Tcl_CmdInfo *infoPtr);"
  (token         tcl-command)
  (cmd-info-ptr  tcl-cmd-info-ptr))




|#


