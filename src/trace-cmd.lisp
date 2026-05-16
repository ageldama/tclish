(in-package #:tclish)



(def-tcl-callback-pattern
    :cb-prefix "trace-cmd"
  :one-off? nil
  :counter-cffi-type :uint64)


(cffi:defcallback %trace-cmd-proc-cb-cfunc :void
    ((client-data  :pointer)
     (interp       tcl-interp-ptr)
     (old-name     :string)
     (new-name     :string)
     (flags        :int))
  (progn
    (trace-cmd/route-by-client-data client-data
                                    :client-data client-data
                                    :interp      interp
                                    :old-name    old-name
                                    :new-name    new-name
                                    :flags       flags)
    ;;
    (when (flags-bit? +tcl-trace-destroyed+ flags)
      (trace-cmd/unregist-cb client-data))))


(defun trace-cmd/enforce-flags (flags)
  (logior flags +tcl-trace-delete+))

(defun trace-cmd/+trace (cmd-name
                         closure
                         &key (flags 0))
  (let* ((registration (trace-cmd/regist-cb closure))
         (client-data  (getf registration :client-data))
         (flags*       (trace-cmd/enforce-flags flags)))
    (do+chk (tcl-trace-command)
            *tcl-interp*
            cmd-name
            flags*
            (cffi:callback %trace-var-proc-cb-cfunc)
            client-data)
    client-data))

(defun trace-cmd/-untrace (cmd-name
                           client-data
                           &key (flags 0))
  (let ((flags*       (trace-cmd/enforce-flags flags)))
    (tcl-untrace-command *tcl-interp* cmd-name
                         flags*
                         (cffi:callback %trace-var-proc-cb-cfunc)
                         client-data)))

(defun trace-cmd/list-all (cmd-name)
  (iter (with prev-client-data = (cffi:null-pointer))
    (for client-data =
         (tcl-command-trace-info
          *tcl-interp*
          cmd-name
          ;; (note that currently the flags are ignored; flags should
          ;; be set to 0 for future compatibility)
          0 ;; =flags
          (cffi:callback %trace-cmd-proc-cb-cfunc)
          prev-client-data))
    (if (cffi:null-pointer-p client-data)
        (terminate)
        (collect client-data))
    (setf prev-client-data client-data)))


