(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :tclish)
  )


(defun mmm-uint-array ()
  (tclish:app-main
      ()

      (tclish:def-cmd/p)

      (let* ((arr-len 10)
             (arr (cffi:make-shareable-byte-vector
                   (* arr-len (cffi:foreign-type-size :uint)))))

        (cffi:with-pointer-to-vector-data (arr-ptr arr)

          ;;(format t "arr: ~a / ~a~%" arr arr-ptr)

          (tclish:do+chk (raw-cffi-tcl9:tcl-link-array)
                         tclish:*tcl-interp*
                         "xarr" arr-ptr
                         raw-cffi-tcl9:+tcl-link-uint+
                         arr-len)

          (tclish:eval-tcl "p {CLEAN: } $xarr")
          (tclish:eval-tcl "lset xarr end 4294967295")
          (tclish:eval-tcl "p {LSET(END) } $xarr")

          (format t "arr: ~a~%" arr)

          (format t "arr(end): ~a~%" 
                  (cffi:mem-aref arr-ptr :uint (1- arr-len)))

          (setf (cffi:mem-aref arr-ptr :uint 0)
                (1- (cffi:mem-aref arr-ptr :uint (1- arr-len))))

          (format t "arr: ~a~%" arr)
          (tclish:eval-tcl "p {: } $xarr")

          (raw-cffi-tcl9:tcl-unlink-var tclish:*tcl-interp* "xarr")

          ))
      ))


