(in-package :tclish)


(defvar *do+chk/error?* t)

(defmacro do+chk
    ((fn-name
      &key
        (interp '*tcl-interp*)
        (tcl-ok +tcl-ok+)
        (error? '*do+chk/error?*)
        (include-error-info? t))
     &rest args)
  (let ((%rc (gensym))
        (%err-msg (gensym)))
    `(let ((,%rc (funcall (fdefinition (quote ,fn-name)) ,@args)))
       (unless (eq ,tcl-ok ,%rc)
         (let ((,%err-msg
                 (format nil "~a FAIL(ret=~a): ~a"
                         (quote ,fn-name)
                         ,%rc
                         (if ,include-error-info?
                             (tcl-get-var ,interp "errorInfo" 0)
                             ;; else:
                             (tcl-get-string-result ,interp)))))
           (if ,error?
               (error ,%err-msg)
               ;; else:
               (format *error-output* "~a~%" ,%err-msg)))))))


(defmacro with-tcl-error/thrown (&rest body)
  `(let ((*do+chk/error?* t)) ,@body))

(defmacro with-tcl-error/result (&rest body)
  `(let ((*do+chk/error?* nil)) ,@body))
