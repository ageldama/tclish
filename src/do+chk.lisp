(in-package :tclish)


(defvar *do+chk/error?* t
  "`DO+CHK` macro treats Tcl error status as raising Lisp error
conditions, not just returning error message strings. (`T` means raise
lisp errors))")

(defmacro do+chk
    ((fn-name
      &key
        (interp '*tcl-interp*)
        (tcl-ok +tcl-ok+)
        (error? '*do+chk/error?*)
        (include-error-info? t))
     &rest args)
  "Runs Tcl C API function (`FN`) and Checks its result-code.

- `ARGS` is a list of arguments to be applied on `FN`.

- `:INTERP` is a Tcl interpreter runs Tcl C API function (`FN`).
- `:TCL-OK` is used to check the result-code of `FN`, specifies code
  for \"No Errors\". (usually `+TCL-OK+`)
- `:ERROR?` asks raising Lisp error condition instead of just returning error message strings.
- `:INCLUDE-ERROR-INFO?` asks that Lisp error condition or error message strings should include the contents of Tcl `errorInfo` variable.
"
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
  "In the `BODY`, `DO+CHK` raises Lisp errors."
  `(let ((*do+chk/error?* t)) ,@body))

(defmacro with-tcl-error/result (&rest body)
  "In the `BODY`, `DO+CHK` returns error message strings without raising Lisp errors."
  `(let ((*do+chk/error?* nil)) ,@body))
