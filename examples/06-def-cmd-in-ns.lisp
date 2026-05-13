
(defpackage #:tclish/examples/06-def-cmd-in-ns
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-def-cmd-in-ns))

(in-package :tclish/examples/06-def-cmd-in-ns)


(defun main-def-cmd-in-ns ()
  (app-main ()
            (cmd/p *tcl-interp*)

            ;; inside of `::myns'
            ;; (create-ns "::myns" :exports '("cmd_inside"))

            (let ((cmd-ns "::myns"))
              (def-cmd ("cmd_inside" :ns cmd-ns)
                       (format t "INSIDE~%")))


            ;; back to global scope:
            (def-cmd ("cmd_global")
                     (format t "GLOBAL~%"))

            ;;
            (labels ((%%tcl-eval (s)
                       (do+chk (tcl-eval) *tcl-interp* s)))
              (%%tcl-eval "cmd_global")
              (%%tcl-eval "::myns::cmd_inside")
              (%%tcl-eval "p {* ns :: => \[ } [namespace children :: *] { \]}")
              (%%tcl-eval "p {* ns ::myns => \[ } [namespace children ::myns *] { \]}")
              (%%tcl-eval "p {* cmds ::myns => \[ } [info commands ::myns::*] { \]}")
              )))

