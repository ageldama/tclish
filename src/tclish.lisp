
(defpackage #:tclish
  (:use #:cl #:iterate #:raw-cffi-tcl9 #:tclish/cffi)
  (:export
   #:*tcl-interp*

   #:*do+chk/error?*
   #:do+chk

   #:mnt-zipfs
   #:umnt-zipfs

   #:create-string-command
   #:create-obj-command

   #:queue-evt-func

   #:def-cmd
   #:interp
   #:args

   #:queue-evt
   #:interp
   #:thread-id
   #:cb-counter

   #:cmd/p

   #:->tcl-string-obj
   #:list->tcl-string-objs
   #:kv-list->dict

   #:list-of-tcl-obj->tcl-list-obj
   #:list-to-pointer-array
   #:free-pointer-array

   #:apply-lambda

   #:wrap-error*
   #:wrap-error
   #:wrap-result

   #:app-main
   ))


(in-package :tclish)



(defvar *tcl-interp* nil)


