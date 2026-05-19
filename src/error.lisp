(in-package :tclish)


(define-condition <tcl-error> (error)
  ((message :initarg :message :reader error-message))
  (:report (lambda (condition stream)
             (format stream "Tcl Error: ~a" (error-message condition)))))


(defun pack-tcl-error
    (&rest args
     &key (condition '<tcl-error>)
       (throw? *do+chk/error?*)
     &allow-other-keys)
  (apply (if throw? #'error #'make-condition)
         condition args))


(defun tcl-result-as-error (&rest args)
  "Extracts `Tcl_GetStringResult` and Converts it into a Lisp condition.

If `*DO+CHK/ERROR?*`=`T`, also raises error condition."
  (let ((err-msg (tcl-get-string-result *tcl-interp*)))
    (apply #'pack-tcl-error :message err-msg args)))


(defun set-tcl-result-string (s)
  "Sets Tcl result state with Lisp string `S`."
  (cffi:with-foreign-string (str-ptr s)
    (tcl-set-obj-result *tcl-interp*
                        (tcl-new-string-obj str-ptr -1))))

(defun set-tcl-result-from-error (an-error)
  "Sets Tcl result state with a string message of Lisp condition
`AN-ERROR`."
  (set-tcl-result-string (format nil "~a" an-error)))
