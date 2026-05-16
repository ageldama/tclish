

#|


Tcl_Trace
Tcl_CreateTrace(interp, level, proc, clientData)

Tcl_Trace
Tcl_CreateObjTrace(interp, level, flags, objProc, clientData, deleteProc)

Tcl_Trace
Tcl_CreateObjTrace2(interp, level, flags, objProc2, clientData, deleteProc)

Tcl_DeleteTrace(interp, trace)



* Tcl_Size level (in)

Only commands at or below this nesting level will be traced unless 0
is specified. 1 means top- level commands only, 2 means top-level
commands or those that are invoked as immediate consequences of
executing top-level commands (procedure bodies, bracketed commands,
etc.) and so on. A value of 0 means that commands at any level are
traced.




 int (Tcl_CmdObjTraceProc) (void *clientData, Tcl_Interp *interp,
	int level, const char *command, Tcl_Command commandInfo, int objc,
	struct Tcl_Obj *const *objv);


 int (Tcl_CmdObjTraceProc2) (void *clientData, Tcl_Interp *interp,
	Tcl_Size level, const char *command, Tcl_Command commandInfo, Tcl_Size objc,
	struct Tcl_Obj *const *objv);



 void (Tcl_CmdTraceProc) (void *clientData, Tcl_Interp *interp,
	int level, char *command, Tcl_CmdProc *proc,
	void *cmdClientData, int argc, const char *argv[]);




|#
