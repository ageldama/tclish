
(defpackage #:tclish/examples/07-ensemble
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-ensemble))

(in-package :tclish/examples/07-ensemble)


(defun main-ensemble ()
  (app-main ()
            (def-cmd/p)

            (def-cmd ("cmd_another") :ANOTHER)

            (def-ensemble ("::myns")
                          (def-cmd ("a") :A)

                          (def-cmd ("b") :B)
                          (ensemble/exclude "b")

                          (def-cmd ("c") :CCCCC)
                          (ensemble/rename "c" :to-ensemble "ccccc")

                          (ensemble/include "another"
                                            :cmd-fqn "::cmd_another")
                          )

            ;; back to global scope:
            (def-cmd ("cmd_global") :GLOBAL)


            ;;
            (eval-tcl "p [cmd_global]"
                      "p [myns a]"
                      "if {[catch {myns b}]} {p {REMOVED: 'myns b'}}"
                      "p [myns ccccc]"
                      "p [myns another]"
                      )))

