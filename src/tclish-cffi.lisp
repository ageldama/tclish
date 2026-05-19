(defpackage #:tclish/cffi
  (:use #:cl #:cffi)
  (:export
   #:c-memset
   #:c-memset*
   #:mem-zero
   #:cffi/alloc+bzero
   #:c-strlen
   #:c-memcpy
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


(defun cffi/alloc+bzero (cffi-type)
  (let ((ptr (cffi:foreign-alloc cffi-type)))
    (mem-zero ptr cffi-type)
    ptr))


(defcfun ("strlen" c-strlen) :size
  (dest :pointer))


(defcfun ("memcpy" c-memcpy) :pointer
  (dest :pointer)
  (src  :pointer)
  (n    :size))


(defun c-string-array-to-string-list (ptr count)
  "Converts an array of C-strings (`PTR` / `char**`) with length of `COUNT` into a
list of lisp strings."
  (loop for i from 0 below count
        for str-ptr = (cffi:mem-aref ptr :pointer i)
        collect (cffi:foreign-string-to-lisp str-ptr)))


(defun c-ptr-array-to-ptr-list (ptr count)
  "Converts an array of C-pointers (`PTR` / `void**`) with length of `COUNT` into a list of CFFI pointers."
  (loop for i from 0 below count
        for obj-ptr = (cffi:mem-aref ptr :pointer i)
        collect obj-ptr))
