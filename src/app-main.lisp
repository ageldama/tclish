(in-package :tclish)




(defmacro app-main
    ((&key
        (do+chk/error? t)

        (tcl-create-interp '(tcl-create-interp))

        tcl-init-subsystems?
        tk-init?
        tk-main-loop?

        zip-filename
        zip-passwd
        (zipfs-mnt-point         "//zipfs:/app")
        (zipfs-tcl-library-path  "/tcl_library")
        (zipfs-tk-library-path   "/tk_library")

        before-create-interp
        before-init
        after-init
        before-deinit
        after-deinit

        stdout-stream
        stderr-stream

        (terminate-without-deinit nil)
        )
     &rest body)
  "Tcl/Tk embedding macro: does initializations/deinitialization of Tcl/Tk.

1. (Optional) use Tk. (use Tcl only)
1. Initializes and Binds `*TCL-INTERP*` special variable.
1. (Optional) Mounts ZipFS for Tcl/Tk deployment
1. (Optional) Redirects Tcl `stdout`/`stderr` channels to Lisp streams.
1. Various \"hooks\" for custom initializations/deinitializations.

It evaluates as `BODY`.

- `:DO+CHK/ERROR?` sets `*DO+CHK/ERROR?*` (Tcl errors as Lisp errors, instead of Lisp string results)

- `:TCL-CREATE-INTERP` : a Lisp form used to create new `Tcl_Interp *`-instance.

- `:TCL-INIT-SUBSYSTEMS?` : Applies `Tcl_InitSubsystems()` during initializations.

- `:TK-INIT?` : Initializes Tk using `Tk_Init()`?
- `:TK-MAIN-LOOP?` : Enters `Tk_MainLoop()` after initializations.

- `:ZIP-FILENAME`, `:ZIP-PASSWD`, `:ZIPFS-MNT-POINT`, `:ZIPFS-TCL-LIBRARY-PATH`, `:ZIPFS-TK-LIBRARY-PATH` : See `MNT-ZIPFS`.

- `:BEFORE-CREATE-INTERP`, `:BEFORE-INIT`, `:AFTER-INIT`, `:BEFORE-DEINIT`, `:AFTER-DEINIT` : Lisp form, customization hook points.

- `:STDOUT-STREAM`, `:STDERR-STREAM` : Tcl `stdout`/`stderr` redirection to Lisp streams, `NIL` = \"No redirections\"

- `:TERMINATE-WITHOUT-DEINIT` : Skips the deinitializations.

"
  ;;
  (let ((%stdout-chan (gensym))
        (%stderr-chan (gensym))
        (%result      (gensym)))
    `(progn
       ,@(when before-create-interp  (list before-create-interp))
       ,@(when tcl-init-subsystems?  `((tcl-init-subsystems)))
       (let* ((*tcl-interp*     ,tcl-create-interp)
              (*do+chk/error?*  ,do+chk/error?)
              (,%result         nil)
              ,@(when stdout-stream
                  `((,%stdout-chan
                     (make-instance
                      'tclish/redir-to-outstream-chan:<redir-to-outstream-chan>
                      :lisp-stream ,stdout-stream
                      :name        "redir-stdout"))))
              ,@(when stderr-stream
                  `((,%stderr-chan
                     (make-instance
                      'tclish/redir-to-outstream-chan:<redir-to-outstream-chan>
                      :lisp-stream ,stderr-stream
                      :name        "redir-stderr")))))

         (unwind-protect
              (progn ,@(when before-init  (list before-init))
                     ,@(when zip-filename
                         `((mnt-zipfs ,zip-filename
                                      :mnt-pointer ,zipfs-mnt-point
                                      :zip-passwd  ,zip-passwd
                                      :tcl-library-path ,zipfs-tcl-library-path
                                      :tk-library-path  ,zipfs-tk-library-path)))
                     (do+chk (tcl-init) *tcl-interp*)
                     ,@(when tk-init? `((do+chk (tk-init) *tcl-interp*)))
                     ,@(when stdout-stream
                         `((tclish/redir-to-outstream-chan:regist
                            ,%stdout-chan :tcl-interp-ptr    *tcl-interp*
                            :tcl-std-chan-type +tcl-stdout+)))
                     ,@(when stderr-stream
                         `((tclish/redir-to-outstream-chan:regist
                            ,%stderr-chan :tcl-interp-ptr    *tcl-interp*
                            :tcl-std-chan-type +tcl-stderr+)))
                     ,@(when after-init (list after-init))
                     (setf ,%result (progn ,@body))
                     ,@(when tk-main-loop? `((tk-main-loop)))
                     ;; result:
                     ,%result)

           ;; cleanup:
           (unless ,terminate-without-deinit
             ,@(when before-deinit (list before-deinit))
             ,@(when zip-filename
                 `((umnt-zipfs :mnt-point ,zipfs-mnt-point)))
             ,@(when stderr-stream `((tclish/redir-to-outstream-chan:dealloc
                                      ,%stderr-chan)))
             ,@(when stdout-stream `((tclish/redir-to-outstream-chan:dealloc
                                      ,%stdout-chan)))
             (tcl-delete-interp *tcl-interp*)
             ,@(when after-deinit (list after-deinit))))))))


