
(defpackage #:tclish/examples/04-redir-stdout
  (:use #:cl #:raw-cffi-tcl9 #:tclish #:tclish/redir-to-outstream-chan)
  (:export #:main-redir-stdout))

(in-package :tclish/examples/04-redir-stdout)


(defun main-redir-stdout ()
  (let ((*tcl-interp* (tcl-create-interp))
        (chan         nil))
    (unwind-protect
         (progn (do+chk (tcl-init) *tcl-interp*)
                (setf chan (make-instance '<redir-to-outstream-chan>
                                          :lisp-stream *standard-output*
                                          :name      "xxx-stdout"
                                          ))
                (regist chan
                        :tcl-interp-ptr    *tcl-interp*
                        :tcl-std-chan-type +tcl-stdout+)
                (do+chk (tcl-eval :error? nil)
                        *tcl-interp*
                        "puts {안녕하슈! HELLO?!}"))
      ;; cleanup:
      (progn
        (when chan (dealloc chan))
        (tcl-delete-interp *tcl-interp*)))))

