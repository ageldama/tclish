(defpackage #:tclish/cffi
  (:use #:cl #:cffi)
  (:export
   #:c-memset
   #:c-memset*
   #:mem-zero
   #:c-strlen
   #:c-string-array-to-string-list
   #:c-ptr-array-to-ptr-list
   ))


(in-package :tclish/cffi)






(defcfun ("memset" c-memset) :pointer
  (dest :pointer)
  (value :int)
  (size :size))


(defmacro c-memset* (ptr ch type-spec)
  `(c-memset ,ptr ,ch
             (cffi:foreign-type-size ,type-spec)))


(defmacro mem-zero (ptr type-spec)
  `(c-memset* ,ptr 0 ,type-spec))


(defcfun ("strlen" c-strlen) :size
  (dest :pointer))



(defun c-string-array-to-string-list (ptr count)
  (loop for i from 0 below count
        for str-ptr = (cffi:mem-aref ptr :pointer i)
        collect (cffi:foreign-string-to-lisp str-ptr)))



(defun c-ptr-array-to-ptr-list (ptr count)
  (loop for i from 0 below count
        for obj-ptr = (cffi:mem-aref ptr :pointer i)
        collect obj-ptr))
