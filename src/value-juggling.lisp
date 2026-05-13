(in-package :tclish)




(defun ->tcl-string-obj
    (val
     &key
       (str-func (lambda (v) (format nil "~a" v))))
  (let ((s-val  (funcall str-func val)))
    (cffi:with-foreign-string (cstr-val s-val)
      (tcl-new-string-obj cstr-val -1))))


(defun list->tcl-string-objs
    (lst &rest args)
  (iter (for i in lst)
    (if (cffi:pointerp i)
        (collect i)
        (collect (apply #'->tcl-string-obj
                        `(,i ,@args))))))


(defun kv-list->dict (interp lst)
  (let ((dict  (tcl-new-dict-obj)))
    (iter (for (k . v) in lst)
      (as k-obj = (->tcl-string-obj k))
      (if (listp v)
          (tcl-dict-obj-put interp dict
                            k-obj (kv-list->dict interp v))
          ;; else:
          (tcl-dict-obj-put interp dict
                            k-obj (->tcl-string-obj v))))
    dict))


(defun list-of-tcl-obj->tcl-list-obj (obj-list)
  (let ((list-ptr (tcl-new-list-obj 0 (cffi:null-pointer))))
    (dolist (obj obj-list)
      (tcl-list-obj-append-element (cffi:null-pointer)
                                   list-ptr obj))
    list-ptr))


(defun list-to-pointer-array (lisp-list)
  (let* ((count (length lisp-list))
         (array-ptr (cffi:foreign-alloc :pointer :count count)))
    (loop for i from 0
          for item in lisp-list
          do (setf (cffi:mem-aref array-ptr :pointer i) item))
    array-ptr))


(defun free-pointer-array (ptr-list)
  (cffi:foreign-free ptr-list))


