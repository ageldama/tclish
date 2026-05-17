(in-package :tclish)


(defun cmd-info/full-name (cmd-obj)
  (let ((result (tcl-new-obj))) ;; refcnt=0
    (unwind-protect
         (progn
           (tcl-incr-ref-count result) ;; refcnt++
           (tcl-get-command-full-name *tcl-interp* cmd-obj result)
           (tcl-get-string-from-obj result (cffi:null-pointer)))
      ;; cleanup:
      (tcl-decr-ref-count result) ;; refcnt-- == 0.
      )))





(defun cmd-info/from-cmd-obj (cmd-obj)
  (let ((cmd-info (cffi/alloc+bzero '(:struct tcl-cmd-info))))
    (do+chk (tcl-get-command-info-from-token :tcl-ok 1)
            cmd-obj cmd-info)
    cmd-info))

(defun cmd-info/free (cmd-info) (cffi:foreign-free cmd-info))


(defun (setf cmd-info/from-cmd-obj) (new-cmd-info cmd-obj)
  (do+chk (tcl-set-command-info-from-token :tcl-ok 1)
          cmd-obj new-cmd-info))


(defmacro with-cmd-info
    ((&key v-cmd-info cmd-obj modify?) &rest body)
  (assert v-cmd-info (v-cmd-info))
  (assert cmd-obj    (cmd-obj))
  `(let ((,v-cmd-info (cmd-info/from-cmd-obj ,cmd-obj)))
     (unwind-protect
          (progn
            ,@body
            (when ,modify?
              (setf (cmd-info/from-cmd-obj ,cmd-obj)
                    ,v-cmd-info)))
       ;; cleanup:
       (cmd-info/free ,v-cmd-info))))


