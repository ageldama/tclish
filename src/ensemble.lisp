(in-package :tclish)


(defvar *def-cmd-tracking-ht* (make-hash-table))


(defmacro track-def-cmds
    (&rest body)
  "Gather invocation of `(FUNCALL *DEF-CMD-TRACKER* FQN :NS .. :NAME ..)`
within `BODY`."
  `(let* ((*def-cmd-tracker*      (lambda (fqn &key ns name)
                                    (declare (ignore ns))
                                    (setf (gethash name *def-cmd-tracking-ht*)
                                          fqn))))
     ,@body
     *def-cmd-tracking-ht*))


(defun create-ensemble
    (ns-fqn ensemble-map-ht &key (interp *tcl-interp*))
  "Creates a Tcl ensemble of Tcl namespace (`NS-FQN`) with (ENSEMBLE-CMD-NAME => CMD-FQN) mapping table (`ENSEMBLE-MAP-HT`).

Returns FFI pointer of the created ensemble object. (`Tcl_Command`)"
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
      &key (interp '*tcl-interp*))
     &rest body)
  "Tcl ensemble defining DSL.

Defines new Tcl ensemble at `NS-FQN` by evaluating the `BODY`.

TODO
"
  ;;
  `(let* ((*def-cmd-ns*           ,ns-fqn)
          (*def-cmd-tracking-ht*  (make-hash-table)))
     (track-def-cmds ,@body)
     (create-ensemble ,ns-fqn *def-cmd-tracking-ht*
                      :interp ,interp)))


(defun ensemble/include (ensemble-name &key cmd-fqn)
  (setf (gethash ensemble-name *def-cmd-tracking-ht*) cmd-fqn))

(defun ensemble/exclude (ensemble-name)
  (remhash ensemble-name *def-cmd-tracking-ht*))

(defun ensemble/rename (from-ensemble &key to-ensemble)
  (let ((fqn-name (gethash from-ensemble *def-cmd-tracking-ht*)))
    (ensemble/exclude from-ensemble)
    (ensemble/include to-ensemble :cmd-fqn fqn-name)))
