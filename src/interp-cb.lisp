(in-package :tclish)

(def-tcl-callback-pattern
    :cb-prefix "call-when-deleted"
  :one-off? t
  :counter-cffi-type :uint16)


(cffi:defcallback %call-when-deleted-cb-cfunc :void
    ((client-data :pointer) (interp tcl-interp-ptr))
  (call-when-deleted/route-by-client-data client-data
                                          :client-data client-data
                                          :interp interp))


(defun call-when-deleted/+add (closure)
  "Registers Tcl interpreter deletion hook callback.

`(CALL-WHEN-DELETED/+ADD closure)` => `client-data`"
  ;;
  (let* ((registration (call-when-deleted/regist-cb closure))
         (client-data  (getf registration :client-data)))
    (tcl-call-when-deleted *tcl-interp*
                           (cffi:callback %call-when-deleted-cb-cfunc)
                           client-data)
    client-data))

(defun call-when-deleted/-del (client-data)
  "Unregisters Tcl interpreter deletion hook callback."
  (tcl-dont-call-when-deleted *tcl-interp*
                              (cffi:callback %call-when-deleted-cb-cfunc)
                              client-data)
  (call-when-deleted/unregist-cb client-data))
