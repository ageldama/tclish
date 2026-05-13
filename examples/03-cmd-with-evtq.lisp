
(defpackage #:tclish/example/03-cmd-with-evtq
  (:use #:cl #:raw-cffi-tcl9 #:tclish)
  (:export #:main-cmd-with-evtq))

(in-package :tclish/example/03-cmd-with-evtq)


(defun main-cmd-with-evtq ()
  (let ((*tcl-interp* (tcl-create-interp)))
    (unwind-protect
         (progn
           (do+chk (tcl-init) *tcl-interp*)

           (create-command
               (:interp *tcl-interp* :name "do_sth_in_thread")
               (format t "DO_STH_IN_THREAD: ~a / ~a~%" interp args)
               (let ((thr (tcl-get-current-thread)))
                 (sb-thread:make-thread
                  (lambda ()
                    (queue-evt
                        (:interp interp :thread-id thr)
                        ;;
                        (format t "~t~a / ~a / ~a~%"
                                interp thread-id cb-counter)
                        (sleep 1)
                        ;; NOTE: Exemplarily BAD!
                        (tcl-set-var interp "forever" "bye" 0))))))

           (create-command
               (:interp *tcl-interp* :name "do_sth_another" :wrap-p t)
               (format t "DO_STH_ANOTHER: ~a ~%" interp))

           ;;
           (do+chk (tcl-eval)
                   *tcl-interp*
                   "do_sth_in_thread; vwait forever; do_sth_another")))
    ;; cleanup:
    (tcl-delete-interp *tcl-interp*)))

