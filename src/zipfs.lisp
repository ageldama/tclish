(in-package :tclish)


(defun mnt-zipfs (zip-filename
                  &key
                    (mnt-point "//zipfs:/app")
                    zip-passwd
                    (tcl-library-path "/tcl_library")
                    (tk-library-path  "/tk_library"))
  "Mounts ZipFS.

- `:ZIP-FILENAME` : A .zip filename to be mounted on `:ZIPFS-MNT-POINTER`. (`NIL` means \"Do not mount zipfs by default\")
- `:ZIP-PASSWD` : Password of .zip file. (`NIL` = no-password)
- `:ZIPFS-MNT-POINT` : ZipFS mount pointer string.
- `:ZIPFS-TCL-LIBRARY-PATH` : Tcl library path under ZipFS, overwrites `tcl_library` Tcl variable.
- `:ZIPFS-TK-LIBRARY-PATH` : Tk library path under ZipFS, overwrites `tk_library` Tcl variable."
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
            "tcl_library" tcl-library-path%
            +tcl-global-only+)
    (do+chk (tcl-set-var)
            *tcl-interp*
            "tk_library" tk-library-path%
            +tcl-global-only+))
  t)


(defun umnt-zipfs (&key (mnt-point "//zipfs:/app"))
  "Unmounts ZipFS"
  (do+chk (tcl-zipfs-unmount) *tcl-interp* mnt-point))


