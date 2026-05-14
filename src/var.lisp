(in-package :tclish)

(defvar *var-flags* +tcl-leave-err-msg+)



;; TODO unset


(defun get-var/str (var-name &key array-subs)
  (let ((result (tcl-get-var2 *tcl-interp*
                var-name
                (lisp-value-or-nullptr array-subs)
                *var-flags*)))
    (if (null result)
        (let ((err-msg (tcl-get-string-result *tcl-interp*)))
          (if *do+chk/error?* (error err-msg) err-msg))
        ;; else:
        result)))

(defun get-var/obj (var-name &key array-subs)
  (let ((result (tcl-obj-get-var2 *tcl-interp*
                                  (->tcl-string-obj var-name)
                                  (->tcl-string-obj array-subs)
                                  *var-flags*)))
    (if (cffi:null-pointer-p result)
        (let ((err-msg (tcl-get-string-result *tcl-interp*)))
          (if *do+chk/error?* (error err-msg) err-msg))
        ;; else:
        result)))


(defun set-var/str (var-name new-val &key array-subs)
  (let ((result (tcl-set-var2 *tcl-interp*
                              var-name
                              (lisp-value-or-nullptr array-subs)
                              new-val
                              *var-flags*)))
    (if (null result)
        (let ((err-msg (tcl-get-string-result *tcl-interp*)))
          (if *do+chk/error?* (error err-msg) err-msg))
        ;; else:
        result)))

(defun set-var/obj (var-name new-val &key array-subs)
  (let ((result (tcl-obj-set-var2 *tcl-interp*
                                  (->tcl-string-obj var-name)
                                  (->tcl-string-obj array-subs)
                                  (->tcl-string-obj new-val)
                                  *var-flags*)))
    (if (cffi:null-pointer-p result)
        (let ((err-msg (tcl-get-string-result *tcl-interp*)))
          (if *do+chk/error?* (error err-msg) err-msg))
        ;; else:
        result)))

(defun chk-get/set-var-as-type (as)
  (assert (member as '(:string :obj)) (as)))


(defun get-var (var-name &key array-subs (as :string))
  (chk-get/set-var-as-type as)
  (case as
    (:obj (get-var/obj var-name :array-subs array-subs))
    (t    (get-var/str var-name :array-subs array-subs))))

(defun set-var (var-name new-val &key array-subs (as :string))
  (chk-get/set-var-as-type as)
  (case as
    (:obj (set-var/obj var-name new-val :array-subs array-subs))
    (t    (set-var/str var-name new-val :array-subs array-subs))))



(defun tcl-var (&rest args) (apply #'get-var args))


(defsetf tcl-var (var-name &key array-subs (as :string)) (new-val)
  `(set-var ,var-name ,new-val :array-subs ,array-subs :as ,as))
