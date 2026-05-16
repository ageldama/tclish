(eval-when (:compile-toplevel :load-toplevel :execute)
  (ql:quickload :tclish)
  )


(defun mmm-uint-array ()
  (tclish:app-main
      ()

      (tclish:def-cmd/p)

      (let* ((arr-init
               #(1 2 3 4 5 6 7 8 9 10))
             (arr (make-instance 'tclish:<tcl-array-link>
                                 :tcl-name "xarr"
                                 :initial-contents arr-init
                                 :var-type raw-cffi-tcl9:+tcl-link-uint+
                                 :size     (length arr-init))))

        (unwind-protect
             (progn
               (tclish:eval-tcl "p {CLEAN: } $xarr")
               (tclish:eval-tcl "lset xarr end 4294967295")
               (tclish:eval-tcl "p {LSET(END) } $xarr")

               (format t "arr(end): ~a~%" 
                       (tclish:linked-value-at arr (1- (length arr-init))))

               (setf (tclish:linked-value-at arr 0)
                     (1- (tclish:linked-value-at arr
                                                 (1- (length arr-init)))))

               (tclish:eval-tcl "p {: } $xarr"))

          (tclish:destroy arr)))))


