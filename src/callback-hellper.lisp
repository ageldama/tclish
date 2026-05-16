(in-package :tclish)



;; TODO one-off?

(defmacro def-tcl-callback-pattern
    (&key
       cb-prefix
       (counter-cffi-type :uint64)
       (closure-map-initform '(make-hash-table)))

  (flet  ((fmt->sym (fmt-str &rest args)
            (read-from-string (apply #'format `(nil ,fmt-str ,@args)))))

    (let ((counter-type-name   (fmt->sym "~a-cb-counter-t" cb-prefix))
          (counter-defvar      (fmt->sym "*~a-cb-counter*" cb-prefix))
          (closure-map-defvar  (fmt->sym "*~a-cb-ht*"      cb-prefix))
          (lock-defvar         (fmt->sym "*~a-cb-lock*"    cb-prefix))
          (lock-name           (format nil "*~a-cb-lock*"  cb-prefix))

          (alloc-counter-cffi-fname (fmt->sym "~a/alloc-counter-cffi"
                                              cb-prefix))
          (free-counter-cffi-fname  (fmt->sym "~a/free-counter-cffi"
                                              cb-prefix))

          (counter-cffi-fname  (fmt->sym "~a/counter-cffi" cb-prefix))

          (closure-fname       (fmt->sym "~a/cb"           cb-prefix))
          (del-closure-fname   (fmt->sym "~a/del-cb"       cb-prefix))
          (incr-counter-fname  (fmt->sym "~a/incr-count"   cb-prefix))

          (regist-fname        (fmt->sym "~a/regist-cb"    cb-prefix))
          (unregist-fname      (fmt->sym "~a/unregist-cb"  cb-prefix))

          (route-by-client-data-fname     (fmt->sym "~a/route-by-client-data"
                                                    cb-prefix))

          )

      `(progn
         ;;; counter
         (cffi:defctype ,counter-type-name ,counter-cffi-type)
         (defvar ,counter-defvar 0)

         ;;; closure-map
         (defvar ,closure-map-defvar ,closure-map-initform)

         ;;; lock
         (defvar ,lock-defvar (funcall #'bt2:make-lock :name ,lock-name))

         ;;; defuns

         (defun ,counter-cffi-fname (counter-ptr)
           (cffi:mem-ref counter-ptr (quote ,counter-type-name)))

         (defun (setf ,counter-cffi-fname) (counter counter-ptr)
           (setf (cffi:mem-ref counter-ptr (quote ,counter-type-name))
                 counter))

         (defun ,alloc-counter-cffi-fname (&optional initial-element)
           (let ((ptr (cffi:foreign-alloc (quote ,counter-type-name))))
             ;;
             (when initial-element
               (setf (,counter-cffi-fname ptr) initial-element))
             ;;
             ptr))

         (defun ,free-counter-cffi-fname (counter-ptr)
           (cffi:foreign-free counter-ptr))

         (defun ,incr-counter-fname ()
           (bt2:with-lock-held (,lock-defvar)
             (incf ,counter-defvar)))

         (defun ,closure-fname (counter)
           (bt2:with-lock-held (,lock-defvar)
             (gethash counter ,closure-map-defvar)))

         (defun (setf ,closure-fname) (closure counter)
           (bt2:with-lock-held (,lock-defvar)
             (setf (gethash counter ,closure-map-defvar) closure)))

         (defun ,del-closure-fname (counter)
           (bt2:with-lock-held (,lock-defvar)
             (remhash counter ,closure-map-defvar)))

         (defun ,regist-fname (closure)
           (let* ((counter       (,incr-counter-fname))
                  (counter-cffi  (,alloc-counter-cffi-fname counter)))
             (setf (,closure-fname counter) closure)
             (list :counter counter
                   :client-data counter-cffi)))

         (defun ,unregist-fname (client-data)
           (let ((counter (,counter-cffi-fname client-data)))
             (,del-closure-fname counter))
           (,free-counter-cffi-fname client-data))

         (defun ,route-by-client-data-fname (client-data &rest args)
           (let* ((counter (,counter-cffi-fname client-data))
                  (cb (,closure-fname counter)))
             (assert cb (cb)
                     "Callback closure not registered? (~a / ~a)"
                     ,cb-prefix counter)
             ;;
             (apply cb args)))


         ))))

