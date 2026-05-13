
(defpackage #:tclish/examples/04-redir-stdout
  (:use #:cl #:raw-cffi-tcl9 #:tclish #:tclish/redir-to-outstream-chan)
  (:export #:main-redir-stdout))

(in-package :tclish/examples/04-redir-stdout)


(defun main-redir-stdout ()
  (app-main ()
            (let ((chan (make-instance '<redir-to-outstream-chan>
                                       :lisp-stream *standard-output*
                                       :name      "xxx-stdout")))
              (unwind-protect
                   (progn (regist chan
                                  :tcl-interp-ptr    *tcl-interp*
                                  :tcl-std-chan-type +tcl-stdout+)
                          (do+chk (tcl-eval :error? nil)
                                  *tcl-interp*
                                  "puts {안녕하슈! HELLO?!}"))
                ;; cleanup:
                (when chan (dealloc chan))))))

