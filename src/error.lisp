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
