(in-package :tclish)

(defconstant +tcl-trace-level-any+       0)
(defconstant +tcl-trace-level-only-top+  1)
(defconstant +tcl-trace-level-only-top-and-one-more+  2)


(def-tcl-callback-pattern
    :cb-prefix "interp-trace"
  :one-off? nil
  :counter-cffi-type :uint64)


(cffi:defcallback %cmd-obj-trace-proc2-cb-cfunc :int
    ((client-data    :pointer)
     (interp         tcl-interp-ptr)
     (level          tcl-size)
     (command        :string)
     (command-info   tcl-command)
     (objc           tcl-size)
     (objv           (:pointer tcl-obj-ptr)))
  (declare (ignorable interp))
  (handler-case
      (progn
        (interp-trace/route-by-client-data
         client-data
         :client-data   client-data
         :level         level
         :command       command
         :command-info  command-info
         :objc          objc
         :objv          objv)
        +tcl-ok+)
    ;;
    (error (c)
      (set-tcl-result-from-error c)
      +tcl-error+)))


(cffi:defcallback %cmd-obj-trace-delete-proc-cb-cfunc :void
    ((client-data :pointer))
  (interp-trace/unregist-cb client-data))



(defun interp-trace/+trace
    (closure
     &key
       (level +tcl-trace-level-any+)
       (flags (->flags-bits* +tcl-allow-inline-compilation+
                             +tcl-trace-enter-exec+
                             +tcl-trace-leave-exec+
                             )))
  ;;
  (let* ((registration (interp-trace/regist-cb closure))
         (client-data  (getf registration :client-data)))
    (values
     (tcl-create-obj-trace2 *tcl-interp*
                            level flags
                            (cffi:callback %cmd-obj-trace-proc2-cb-cfunc)
                            client-data
                            (cffi:callback %cmd-obj-trace-delete-proc-cb-cfunc))
     client-data)))



(defun interp-trace/-delete (trace)
  (tcl-delete-trace *tcl-interp* trace))


