(in-package :tclish)


(define-condition <tcl-error> (error)
  ((message :initarg :message :reader error-message))
  (:report (lambda (c stream)
             (format stream "Tcl Error: ~a" (error-message c)))))


(defun pack-tcl-error
    ;; TODO
    (&key (condition '<tcl-error>) throw?)
  (apply (if throw? #'error #'make-condition)
         condition args))
