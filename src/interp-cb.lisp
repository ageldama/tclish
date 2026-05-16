(in-package :tclish)

(def-tcl-callback-pattern
    :cb-prefix "call-when-deleted"
  :counter-cffi-type :uint16)


(cffi:defcallback %call-when-deleted-cb-cfunc :void
  ((client-data  :pointer)
   (interp       tcl-interp-ptr))
  ;;
  (let* ((counter (call-when-deleted/counter-cffi client-data))
         (cb (call-when-deleted/cb counter)))
    (if cb (funcall cb
                    :counter counter
                    :client-data client-data
                    :interp interp)
        (error "Callback not found (CALL-WHEN-DELETED/Nr:~a)"
               counter))))



(defun call-when-deleted/+add (closure)
 "(CALL-WHEN-DELETED/+ADD closure) => (VALUES counter client-data)"
 ;;
 (let* ((counter (call-when-deleted/incr-count))
        (counter-cffi (call-when-deleted/alloc-counter-cffi counter)))
   (setf (call-when-deleted/cb counter) closure)
   (tcl-call-when-deleted *tcl-interp*
                          (cffi:callback %call-when-deleted-cb-cfunc)
                          counter-cffi)
   (values counter counter-cffi)))


(defun call-when-deleted/-del (counter client-data)
  (declare (ignore counter))
  (tcl-dont-call-when-deleted *tcl-interp*
                              (cffi:callback %call-when-deleted-cb-cfunc)
                              client-data))


