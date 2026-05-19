(in-package :tclish)

(defun eval-tcl (&rest cmds)
  "Evaluates given Tcl commands(`CMDS`) sequentially and returns the last result.

- if `CMDS` has a sequence of `:RESULT-AS :OBJ` or `:RESULT-AS :STRING`, returning value will be a `TCL-OBJ-PTR` or a Lisp string.

- each element of `CMDS` can be one of:
  - a Lisp string.
  - a Lisp list can be a form of:
    - `(LIST :TCL-STRING TCL-STR-PTR)`
    - `(LIST :TCL-OBJV OBJV-TCL-OBJ-PTR OBJC)` where `OBJC` is a number.
    - or `(LIST TCL-OBJ-PTR-1 .. TCL-OBJ-PTR-N)`
"
  (assert (and *tcl-interp*
               (not (cffi:null-pointer-p *tcl-interp*)))
          (*tcl-interp*))
  ;;
  (let* ((result-as :string)
         (cmds* (iter (generating gel in cmds)
                  (for el = (next gel))
                  (case el
                    (:result-as
                     (progn
                       (setf result-as (next gel))
                       (assert (or (null result-as)
                                   (member result-as '(:obj :string)))
                               (result-as))))
                    (t          (collect el))))))
    ;;
    (dolist (cmd cmds*)
      (cond
        ((listp cmd) (case (first cmd)
                       (:tcl-string (eval-tcl/tcl-string (second cmd)))
                       (:tcl-objv   (eval-tcl/tcl-objv (third cmd) (second cmd)))
                       (t           (eval-tcl/tcl-obj-list cmd))))
        (t (eval-tcl/str cmd))))
    (result-as result-as)))


(defun eval-tcl/str (cmd)
  "Evalutes Tcl script `CMD` and checks the result code.

Affected by `*DO+CHK/ERROR?*`."
  (do+chk (tcl-eval) *tcl-interp* cmd))


(defun eval-tcl/tcl-obj-list (cmd-list)
  "Evaluates a list of Tcl string FFI pointers. (`CMD-LIST`)

Affected by `*DO+CHK/ERROR?*`."
  "(list Tcl_Obj*)"
  (with-tcl-objv (cmd-list)
    (eval-tcl/tcl-objv tcl-objv tcl-objc)))


(defun eval-tcl/tcl-string (cmd)
  "Evaluates a Tcl string FFI pointer. (`CMD`)

Affected by `*DO+CHK/ERROR?*`."
  (do+chk (tcl-eval-obj) *tcl-interp* cmd))


(defun eval-tcl/tcl-objv (objv objc)
  "Evaluates an array of Tcl object pointers. (`OBJV`/`OBJC`).

Affected by `*DO+CHK/ERROR?*`."
  (do+chk (tcl-eval-objv) *tcl-interp* objc objv 0))



(defun result-as (result-as)
  (case result-as
    (:string (tcl-get-string-result *tcl-interp*))
    (:obj    (tcl-get-obj-result *tcl-interp*))
    (t       nil)))


