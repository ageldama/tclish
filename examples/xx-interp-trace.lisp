

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
is speci‐ fied. 1 means top- level commands only, 2 means top-level
commands or those that are invoked as immediate conse‐ quences of
executing top-level commands (procedure bodies, bracketed commands,
etc.) and so on. A value of 0 means that commands at any level are
traced.




|#
