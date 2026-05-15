
(defpackage #:tclish
  (:use #:cl #:iterate #:raw-cffi-tcl9 #:tclish/cffi)
  (:export

   #:*tcl-interp*

   #:with-interp
   #:interp/deleted? #:interp/active?
   #:interp/safe? #:interp/parent #:interp/child
   #:interp/create-child #:interp/interp-path
   #:interp/expose-cmd #:interp/hide-cmd

   #:<tcl-error> #:error-message #:pack-tcl-error
   #:tcl-result-as-error

   #:*do+chk/error?* #:do+chk
   #:with-tcl-error/thrown #:with-tcl-error/result

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

   #:*def-cmd-tracking-ht*
   #:track-def-cmds
   #:create-ensemble
   #:def-ensemble
   #:ensemble/include
   #:ensemble/exclude
   #:ensemble/rename

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

   #:objv->tcl-obj-list

   #:lisp-value-or-nullptr
   #:lisp-bool->c-int
   #:nullptr->nil
   #:<-tcl-int-bool

   #:get-var/str #:get-var/obj #:set-var/str #:set-var/obj
   #:get-var #:set-var #:tcl-var #:unset-var

   #:apply-lambda

   #:wrap-error*
   #:wrap-error
   #:wrap-result

   #:result-as
   #:eval-tcl
   #:eval-tcl/str
   #:eval-tcl/tcl-obj-list
   #:eval-tcl/tcl-string
   #:eval-tcl/tcl-objv

   #:app-main

   #:alias/get
   ))


(in-package :tclish)



(defvar *tcl-interp* nil)


