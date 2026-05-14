
(defpackage #:tclish/examples/12-trace-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/12-trace-var)


(defun main ()
  (app-main ()
            ))



#|


/* 248 */ EXTERN int
Tcl_TraceVar2(
  Tcl_Interp *interp, const char *part1,
  const char *part2, int flags,
  Tcl_VarTraceProc *proc, void *clientData);


/* 256 */ EXTERN void
Tcl_UntraceVar2(
  Tcl_Interp *interp, const char *part1, const char *part2,
  int flags, Tcl_VarTraceProc *proc,
  void *clientData);



/* 262 */ EXTERN void * /*=clientData*/
Tcl_VarTraceInfo2(
  Tcl_Interp *interp, const char *part1, const char *part2,
  int flags, Tcl_VarTraceProc *procPtr, void *prevClientData);




flags:

TCL_TRACE_READS,    TCL_TRACE_WRITES,
TCL_TRACE_UNSETS,    TCL_TRACE_ARRAY,
TCL_GLOBAL_ONLY,  TCL_NAMESPACE_ONLY,
TCL_TRACE_RESULT_DYNAMIC
TCL_TRACE_RESULT_OBJECT


       TCL_TRACE_RESULT_DYNAMIC
              The result of invoking the proc is a dynamically allocated string
              that  will be released by the Tcl library via a call to Tcl_Free.
              Must not be specified at the same  time  as  TCL_TRACE_RESULT_OB‐
              JECT.

       TCL_TRACE_RESULT_OBJECT
              The  result  of invoking the proc is a Tcl_Obj* (cast to a char*)
              with a reference count of at least one.  The  ownership  of  that
              reference  will  be transferred to the Tcl core for release (when
              the core has finished with it) via a  call  to  Tcl_DecrRefCount.
              Must  not  be  specified at the same time as TCL_TRACE_RESULT_DY‐
              NAMIC.


typedef char *Tcl_VarTraceProc(
                      void *clientData,
                      Tcl_Interp *interp,
                      const char *name1,
                      const char *name2,
                      int flags);

Under  normal conditions trace procedures should return NULL, indicating
successful completion.  If proc returns a non-NULL  value  it  signifies
that  an error occurred.  The return value must be a pointer to a static
character string containing an error message, unless  (exactly  one  of)
the  TCL_TRACE_RESULT_DYNAMIC  and TCL_TRACE_RESULT_OBJECT flags is set,


       In  an  unset  callback  to  proc, the TCL_TRACE_DESTROYED bit is set in
       flags if the trace is being removed as part of the deletion.  Traces  on
       a  variable  are  always  removed whenever the variable is deleted;  the
       only time TCL_TRACE_DESTROYED is not set is for a whole-array trace  in‐
       voked when only a single element of an array is unset.



|#
