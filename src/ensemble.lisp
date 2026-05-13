(in-package :tclish)


(defmacro track-def-cmds
    ((&key var-ensemble-map-ht) &rest body)
  (let ((%ensemble-map-ht (gensym)))
    `(let* ((,%ensemble-map-ht  (make-hash-table))
            ,@(when var-ensemble-map-ht
                `((,var-ensemble-map-ht ,%ensemble-map-ht)))
            (*def-cmd-tracker*  (lambda (fqn &key ns name)
                                  (declare (ignore ns))
                                  (setf (gethash name ,%ensemble-map-ht)
                                        fqn))))
       ,@body
       ,%ensemble-map-ht)))


(defun create-ensemble
    (ns-fqn ensemble-map-ht &key (interp *tcl-interp*))
  ;;
  (let* ((ns-ptr       (tcl-ns ns-fqn :interp interp))
         (ensemble-ptr (raw-cffi-tcl9:tcl-create-ensemble
                        interp ns-fqn ns-ptr 0))
         (ensemble-map-dict (ht->tcl-dict interp ensemble-map-ht)))
    ;;
    (assert (not (cffi:null-pointer-p ensemble-ptr)) (ensemble-ptr))
    (do+chk (raw-cffi-tcl9:tcl-set-ensemble-mapping-dict
             :interp interp)
            interp ensemble-ptr ensemble-map-dict)
    ensemble-ptr))


(defmacro def-ensemble
    ((ns-fqn
      &key (interp '*tcl-interp*)
        var-ensemble-map-ht)
     &rest body)
  ;;
  (let ((%ensemble-map-ht (gensym)))
    `(let* ((*def-cmd-ns* ,ns-fqn)
            (,%ensemble-map-ht
              (track-def-cmds
                  (:var-ensemble-map-ht ,var-ensemble-map-ht)
                  ,@body)))
       (create-ensemble ,ns-fqn ,%ensemble-map-ht
                        :interp ,interp))))

