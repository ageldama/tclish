
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
   #:*def-cmd-ns*
   #:*def-cmd-tracker*
   #:interp
   #:args

   #:tcl-ns

   #:track-def-cmds
   #:create-ensemble
   #:def-ensemble

   #:queue-evt
   #:interp
   #:thread-id
   #:cb-counter

   #:def-cmd/p

   #:->tcl-string-obj
   #:list->tcl-string-objs
   #:alist->tcl-dict
   #:ht->tcl-dict

   #:list-of-tcl-obj->tcl-list-obj
   #:list-to-pointer-array
   #:free-pointer-array

   #:apply-lambda

   #:wrap-error*
   #:wrap-error
   #:wrap-result

   #:eval-tcl

   #:app-main
   ))


(in-package :tclish)



(defvar *tcl-interp* nil)


