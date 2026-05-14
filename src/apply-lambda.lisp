(in-package :tclish)



(defun apply-lambda
    (interp lambda-str args
     &key (result-as-obj? nil))
  (let* ((lambda-obj (->tcl-string-obj lambda-str))
         (objs-args  (list->tcl-string-objs args))
         (objv-list  `(,(->tcl-string-obj "apply") ,lambda-obj ,@objs-args))
         (objv       (list-to-pointer-array objv-list))
         (result     nil)
         (*tcl-interp* interp))

    (unwind-protect
         (progn
           (dolist (i objv-list) (tcl-incr-ref-count i))
           (do+chk (tcl-eval-objv)
                   interp (length objv-list) objv 0)
           (setf result
                 (if result-as-obj?
                     (tcl-get-obj-result interp)
                     (tcl-get-string-result interp)))
           (dolist (i objv-list) (tcl-decr-ref-count i))
           ;; done:
           result)
      ;; cleanup:
      (free-pointer-array objv))))


