(in-package :tclish)




(defmacro app-main
    ((&key
        (do+chk/error? t)

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
        )
     &rest body)
  ;;
  (let ((%stdout-chan (gensym))
        (%stderr-chan (gensym)))
    `(progn
       ,(when before-create-interp  before-create-interp)
       ,(when tcl-init-subsystems?  `(tcl-init-subsystems))
       (let* ((*tcl-interp*     (tcl-create-interp))
              (*do+chk/error?*  ,do+chk/error?)
              ;; TODO
              )
         (unwind-protect
              (progn ,(when before-init  before-init)
                     ,(when zip-filename
                        `(mnt-zipfs ,zip-filename
                                    :mnt-pointer ,zipfs-mnt-point
                                    :zip-passwd  ,zip-passwd
                                    :tcl-library-path ,zipfs-tcl-library-path
                                    :tk-library-path  ,zipfs-tk-library-path))
                     (do+chk (tcl-init) *tcl-interp*)
                     ,(when tk-init? `(do+chk (tk-init) *tcl-interp*))
                     ,(when after-init after-init)
                     (progn ,@body)
                     ,(when tk-main-loop? `(tk-main-loop)))
           ;; cleanup:
           (progn
             ,(when before-deinit before-deinit)
             ,(when zip-filename
                `(umnt-zipfs :mnt-point ,zipfs-mnt-point))
             (tcl-delete-interp *tcl-interp*)
             ,(when after-deinit after-deinit)))))))
