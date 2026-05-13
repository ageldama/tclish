
(defpackage #:tclish/examples/07-ensemble
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-ensemble))

(in-package :tclish/examples/07-ensemble)


(defun main-ensemble ()
  (app-main ()
            (cmd/p *tcl-interp*)

            (def-ensemble ("::myns")
                          (def-cmd ("a") :A)
                          (def-cmd ("b") :B))

            ;; back to global scope:
            (def-cmd ("cmd_global") :GLOBAL)


            ;;
            (eval-str "p [cmd_global]"
                      "p [myns a]"
                      "p [myns b]"
                      )))

