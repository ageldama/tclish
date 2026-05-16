(defpackage  #:tclish/examples/14-call-when-deleted
  (:use #:cl #:tclish #:raw-cffi-tcl9)
  (:export :main))

(in-package :tclish/examples/14-call-when-deleted)


(defun main ()
  (tclish:app-main
      ()

      (call-when-deleted/+add (lambda (&rest args &key client-data &allow-other-keys)
                                (declare (ignore args))
                                (call-when-deleted/free-counter-cffi client-data)
                                (format t "BYEBYE!~%")))


      (let ((client-data
              (call-when-deleted/+add (lambda (&rest args)
                                        (declare (ignore args))
                                        (format t "NEVER SEE THIS~%")))))
            ;; delete it before triggers
            (call-when-deleted/-del client-data))

      ))



