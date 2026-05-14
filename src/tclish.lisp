
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

   #:*stringify-for-tcl-obj-func*
   #:->tcl-string-obj
   #:list->tcl-string-list
   #:list->tcl-list
   #:tcl-obj-list->tcl-list

   #:with-tcl-objv
   #:tcl-objv
   #:tcl-objc

   #:alist->tcl-dict
   #:ht->tcl-dict

   #:tcl-obj-list->objv
   #:free-tcl-objv

   #:apply-lambda

   #:wrap-error*
   #:wrap-error
   #:wrap-result

   #:result-as
   #:eval-tcl

   #:app-main
   ))


(in-package :tclish)



(defvar *tcl-interp* nil)


