(in-package :tclish)




(defvar *stringify-for-tcl-obj-func*
  (lambda (v) (format nil "~a" v)))


(defun ->tcl-string-obj% (val)
  (let ((s-val  (funcall *stringify-for-tcl-obj-func*
                         val)))
    (cffi:with-foreign-string (cstr-val s-val)
      (tcl-new-string-obj cstr-val -1))))

(defun ->tcl-string-obj (val)
  (if (null val)
      (cffi:null-pointer)
      ;; else:
      (if (cffi:pointerp val)
          val
          (->tcl-string-obj% val))))


(defun list->tcl-string-list (lst)
  "(LIST lisp-value-1 tcl-obj-2 ... lisp-value-N) => (LIST tcl-obj-1 tcl-obj-2 ... tcl-obj-N)"
  (iter (for i in lst)
    (collect (->tcl-string-obj i))))




(defun ht->tcl-dict (interp ht)
  (iter (with dict = (tcl-new-dict-obj))
    (for (k v) in-hashtable ht)
    (as k-obj = (->tcl-string-obj k))
    (if (hash-table-p v)
        (tcl-dict-obj-put interp dict
                          k-obj (ht->tcl-dict interp v))
        ;; else:
        (tcl-dict-obj-put interp dict
                          k-obj (->tcl-string-obj v)))
    (finally (return dict))))



(defun alist->tcl-dict (interp lst)
  (iter (with dict = (tcl-new-dict-obj))
    (for (k . v) in lst)
    (as k-obj = (->tcl-string-obj k))
    (if (listp v)
        (tcl-dict-obj-put interp dict
                          k-obj (alist->tcl-dict interp v))
        ;; else:
        (tcl-dict-obj-put interp dict
                          k-obj (->tcl-string-obj v)))
    (finally (return dict))))


(defun list->tcl-list (lst)
  "(LIST lisp-value-1 tcl-obj-2 ... lisp-value-N) => (VALUES tcl-list tcl-list-length)"
  (iter (with list-ptr = (tcl-new-list-obj 0 (cffi:null-pointer)))
    (for item in lst)
    (counting item into counter)
    (tcl-list-obj-append-element (cffi:null-pointer)
                                 list-ptr
                                 (->tcl-string-obj item))
    (finally (return (values list-ptr counter)))))


(defun tcl-obj-list->tcl-list (obj-list)
  "(LIST tcl-obj-1 ... tcl-obj-N) => (VALUES tcl-list tcl-list-length)"
  (let ((list-ptr (tcl-new-list-obj 0 (cffi:null-pointer))))
    (dolist (obj obj-list)
      (tcl-list-obj-append-element (cffi:null-pointer)
                                   list-ptr obj))
    (values list-ptr (length obj-list))))


(defmacro with-tcl-objv ((lst
                          &key (v-tcl-objv 'tcl-objv)
                            (v-tcl-objc 'tcl-objc))
                         &rest body)
  (let ((%lst-tcl-objs   (gensym))
        (%result         (gensym)))
    `(let* ((,%lst-tcl-objs (list->tcl-string-list ,lst))
            (,v-tcl-objc    (length ,lst))
            (,v-tcl-objv    (tcl-obj-list->objv ,%lst-tcl-objs))
            (,%result       nil))
       (unwind-protect
            (progn (dolist (obj ,%lst-tcl-objs) (tcl-incr-ref-count obj))
                   (setf ,%result (progn ,@body))
                   (dolist (obj ,%lst-tcl-objs) (tcl-decr-ref-count obj)))
         ;; cleanup:
         (free-tcl-objv ,v-tcl-objv))
       ,%result)))


(defun tcl-obj-list->objv (tcl-obj-list)
  "(LIST tcl-obj-1 ... tcl-obj-N) => Tcl_Obj*[]"
  (let* ((count    (length tcl-obj-list))
         (objv-ptr (cffi:foreign-alloc :pointer :count count)))
    (loop for i from 0
          for obj-ptr in tcl-obj-list
          do (setf (cffi:mem-aref objv-ptr :pointer i) obj-ptr))
    (values objv-ptr count)))


(defun free-tcl-objv (objv-ptr)
  (cffi:foreign-free objv-ptr))



(defun lisp-value-or-nullptr (val)
  (if val val (cffi:null-pointer)))


(defun lisp-bool->c-int (val) (if val 1 0))


(defun nullptr->nil (cval)
  (if (cffi:null-pointer-p cval) nil cval))



