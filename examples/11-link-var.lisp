
(defpackage #:tclish/examples/11-link-var
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main))

(in-package :tclish/examples/11-link-var)


(defun main ()
  (app-main ()
            ))



#|


       int
       Tcl_LinkVar(interp, varName, addr, type)

       int                                                                      2
       Tcl_LinkArray(interp, varName, addr, type, size)                         2

       Tcl_UnlinkVar(interp, varName)

       Tcl_UpdateLinkedVar(interp, varName)





       int type (in)                    Type of C variable for  Tcl_LinkVar  or
                                        type  of  array element for Tcl_LinkAr‐
                                        ray.   Must  be  one  of  TCL_LINK_INT,
                                        TCL_LINK_UINT,           TCL_LINK_CHAR,
                                        TCL_LINK_UCHAR,         TCL_LINK_SHORT,
                                        TCL_LINK_USHORT,         TCL_LINK_LONG,
                                        TCL_LINK_ULONG,      TCL_LINK_WIDE_INT,
                                        TCL_LINK_WIDE_UINT,     TCL_LINK_FLOAT,
                                        TCL_LINK_DOUBLE,  TCL_LINK_BOOLEAN,  or
                                        one of the extra ones listed below.

                                        In  Tcl_LinkVar,  the additional linked
                                        type TCL_LINK_STRING may be used.

                                        In Tcl_LinkArray, the additional linked 2
                                        types TCL_LINK_CHARS  and  TCL_LINK_BI‐ 2
                                        NARY may be used.

                                        All the above for both functions may be
                                        optionally          OR'ed          with
                                        TCL_LINK_READ_ONLY  to  make  the   Tcl
                                        variable read-only.


       TCL_LINK_STRING
              The C variable is of type char *.  If its value is not NULL  then
              it must be a pointer to a string allocated with Tcl_Alloc.  When‐
              ever  the  Tcl  variable is modified the current C string will be
              freed and new memory will be allocated to  hold  a  copy  of  the
              variable's  new value.  If the C variable contains a NULL pointer
              then the Tcl variable will read as “NULL”.   This  is  only  sup‐
              ported by Tcl_LinkVar.



|#
