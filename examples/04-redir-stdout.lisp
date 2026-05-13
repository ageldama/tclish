
(defpackage #:tclish/examples/04-redir-stdout
  (:use #:cl #:raw-cffi-tcl9 #:tclish #:tclish/redir-to-outstream-chan)
  (:export #:main-redir-stdout))

(in-package :tclish/examples/04-redir-stdout)


(defun main-redir-stdout ()
  (app-main (:stdout-stream *standard-output*)
            (do+chk (tcl-eval :error? nil)
                    *tcl-interp*
                    "puts {안녕하슈! HELLO?!}")))

