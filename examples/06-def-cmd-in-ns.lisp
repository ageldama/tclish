
(defpackage #:tclish/examples/06-def-cmd-in-ns
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-def-cmd-in-ns))

(in-package :tclish/examples/06-def-cmd-in-ns)


(defun main-def-cmd-in-ns ()
  (app-main ()
            (def-cmd/p)

            ;; inside of `::myns'
            ;; (create-ns "::myns" :exports '("cmd_inside"))

            (let ((*def-cmd-ns* "::myns"))
              (def-cmd ("cmd_inside")
                       (format t "INSIDE~%")))

            ;; back to global scope:
            (def-cmd ("cmd_global")
                     (format t "GLOBAL~%"))

            ;;
            (eval-tcl "cmd_global"
                      "::myns::cmd_inside"
                      "p {* ns :: => \[ } [namespace children :: *] { \]}"
                      "p {* ns ::myns => \[ } [namespace children ::myns *] { \]}"
                      "p {* cmds ::myns => \[ } [info commands ::myns::*] { \]}")))

