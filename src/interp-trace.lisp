(in-package :tclish)

(defconstant +tcl-trace-level-any+       0)
(defconstant +tcl-trace-level-top-only+  1)
(defconstant +tcl-trace-level-top-and-only-one-more+  2)

#|



Tcl_Trace
Tcl_CreateObjTrace2(interp, level, flags, objProc2, clientData, deleteProc)


Tcl_DeleteTrace(interp, trace)



 int (Tcl_CmdObjTraceProc2) (void *clientData, Tcl_Interp *interp,
	Tcl_Size level, const char *command, Tcl_Command commandInfo, Tcl_Size objc,
	struct Tcl_Obj *const *objv);


 void Tcl_CmdObjTraceDeleteProc(void * clientData);




The objProc callback is expected to return a standard Tcl status
return code. If this code is TCL_OK (the normal case), then the Tcl
inter‐ preter will invoke the command. Any other return code is
treated as if the command returned that status, and the command is not
invoked.

The objProc callback must not modify objv in any way.

You should not call Tcl_DecrRefCount on any of those values unless you
call Tcl_IncrRefCount on them first.




The token may be passed to Tcl_GetCommandName,
Tcl_GetCommandInfoFromToken, or Tcl_SetCommandInfoFromToken to
manipulate the definition of the command.


int
Tcl_GetCommandInfoFromToken(token, infoPtr)

              typedef struct {
                  int isNativeObjectProc;
                  Tcl_ObjCmdProc *objProc;
                  void *objClientData;
                  Tcl_CmdProc *proc;
                  void *clientData;
                  Tcl_CmdDeleteProc *deleteProc;
                  void *deleteData;
                  Tcl_Namespace *namespacePtr;
                  Tcl_ObjCmdProc2 *objProc2;
                  void *objClientData2;
              } Tcl_CmdInfo;


int
Tcl_SetCommandInfoFromToken(token, infoPtr)

       Tcl_SetCommandInfo  is used to modify the procedures and clientData val‐
       ues associated with a command.  Its cmdName argument is the  name  of  a
       command in interp.  cmdName may include :: namespace qualifiers to iden‐
       tify  a command in a particular namespace.  If this command does not ex‐
       ist then Tcl_SetCommandInfo returns 0.  Otherwise, it copies the  infor‐
       mation from *infoPtr to Tcl's internal structure for the command and re‐
       turns 1.

       Tcl_SetCommandInfoFromToken  is  identical  to Tcl_SetCommandInfo except
       that it takes a command token...




Tcl_GetCommandFullName(interp, token, objPtr)

       Tcl_GetCommandFullName does not modify the reference count of its objPtr
       argument, but does require that the object be unshared.




|#
