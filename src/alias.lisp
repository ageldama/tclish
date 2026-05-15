(in-package :tclish)



(defun alias/get (child-cmd)
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









#|

       int
       Tcl_CreateAlias(childInterp, childCmd, targetInterp, targetCmd,
                       argc, argv)

       int
       Tcl_CreateAliasObj(childInterp, childCmd, targetInterp, targetCmd,
                          objc, objv)


|#
