(in-package :tclish)


(defun mnt-zipfs (zip-filename
                  &key
                    (mnt-point "//zipfs:/app")
                    zip-passwd
                    (tcl-library-path "/tcl_library")
                    (tk-library-path  "/tk_library"))
  (let ((tcl-library-path% (concatenate 'string mnt-point
                                        tcl-library-path))
        (tk-library-path%  (concatenate 'string mnt-point
                                        tk-library-path)))
    (assert (uiop:file-exists-p zip-filename)
            (zip-filename)
            "no-zip-file ~a" zip-filename)
    (do+chk (tcl-zipfs-mount)
            *tcl-interp* zip-filename mnt-point zip-passwd)
    (do+chk (tcl-set-var)
            *tcl-interp*
            "tcl-library-path" tcl-library-path%
            +tcl-global-only+)
    (do+chk (tcl-set-var)
            *tcl-interp*
            "tk-library-path" tk-library-path%
            +tcl-global-only+))
  t)


(defun umnt-zipfs (&key (mnt-point "//zipfs:/app"))
  (do+chk (tcl-zipfs-unmount) *tcl-interp* mnt-point))


