(in-package :tclish)



(defun alias/get (child-cmd)
  "`Tcl_GetAliasObj` => `(LIST :target-interp CFFI-PTR :target-cmd STRING :objc NUMBER :objv (LIST TCL-OBJ-PTR))`"
  (let ((tgt-interp-ptr (cffi:make-pointer 0)))
    (cffi:with-foreign-objects ((tgt-cmd-ptr     :pointer)
                                (objc-ptr        :pointer)
                                (objv-ptr        :pointer))
      (do+chk (tcl-get-alias-obj)
              *tcl-interp* child-cmd
              (cffi:mem-ref tgt-interp-ptr :pointer)
              (cffi:mem-ref tgt-cmd-ptr    :pointer)
              (cffi:mem-ref objc-ptr       :pointer)
              (cffi:mem-ref objv-ptr       :pointer))
      (let ((objc          (cffi:mem-ref 'tcl-size objc-ptr)))
      (list :target-interp tgt-interp-ptr
            :target-cmd    (cffi:foreign-string-to-lisp tgt-cmd-ptr)
            :objc          objc
            :objv          (objv->tcl-obj-list objc objv-ptr))))))


(defun alias/str
    (&key child-interp child-cmd tgt-interp tgt-cmd argv)
  "`Tcl_CreateAlias`"
  (assert child-interp  (child-interp))
  (assert child-cmd     (child-cmd))
  (assert tgt-interp    (tgt-interp))
  (assert tgt-cmd       (tgt-cmd))
  ;;
  (do+chk (tcl-create-alias)
          child-interp child-cmd
          tgt-interp   tgt-cmd
          (length argv) argv))


(defun alias/obj
    (&key child-interp child-cmd tgt-interp tgt-cmd tcl-obj-list-objv)
  "`Tcl_CreateAliasObj`"
  (assert child-interp  (child-interp))
  (assert child-cmd     (child-cmd))
  (assert tgt-interp    (tgt-interp))
  (assert tgt-cmd       (tgt-cmd))
  ;;
  (multiple-value-bind (objv-ptr objc) (tcl-obj-list->objv tcl-obj-list-objv)
    (do+chk (tcl-create-alias-obj)
            child-interp child-cmd
            tgt-interp tgt-cmd
            objc objv-ptr)))


