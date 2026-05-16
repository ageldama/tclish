(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :tclish)
  )


(defun mmm-uint-array ()
  (tclish:app-main
      ()

      (tclish:def-cmd/p)

      (let* ((arr-len 10)
             (arr (cffi:foreign-alloc :uint
                                      :count arr-len
                                      :initial-contents
                                      #(1 2 3 4 5 6 7 8 9 10))))
        (unwind-protect

             (progn
               (tclish:do+chk (raw-cffi-tcl9:tcl-link-array)
                              tclish:*tcl-interp*
                              "xarr" arr
                              raw-cffi-tcl9:+tcl-link-uint+
                              arr-len)

               (tclish:eval-tcl "p {CLEAN: } $xarr")
               (tclish:eval-tcl "lset xarr end 4294967295")
               (tclish:eval-tcl "p {LSET(END) } $xarr")

               ;;(format t "arr: ~a~%" arr)

               (format t "arr(end): ~a~%" 
                       (cffi:mem-aref arr :uint (1- arr-len)))

               (setf (cffi:mem-aref arr :uint 0)
                     (1- (cffi:mem-aref arr :uint (1- arr-len))))

               (tclish:eval-tcl "p {: } $xarr")

               (raw-cffi-tcl9:tcl-unlink-var tclish:*tcl-interp* "xarr"))

          (cffi:foreign-free arr)

          ))
      ))


