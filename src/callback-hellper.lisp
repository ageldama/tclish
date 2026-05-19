(in-package :tclish)



(defmacro def-tcl-callback-pattern
    (&key
       cb-prefix
       one-off?
       (counter-cffi-type :uint64)
       (closure-map-initform '(make-hash-table))
       ;;(lock-timeout 1)
       )
  "Generates definitions & codes for interacting with Tcl C callback mechanisms.

- `:CB-PREFIX` is mandatory, and will be used to prefixing every generated definitions and functions.
- `:ONE-OFF?` indicates the registered callbak should be cleaned up once it has invoked, never meant to be used twice or more.


This macro defines:

- `${:CB-PREFIX}-CB-COUNTER-T` CFFI type
- `*${:CB-PREFIX}-CB-COUNTER*` variable
- `*${:CB-PREFIX}-CB-HT*` variable
- `*${:CB-PREFIX}-CB-LOCK*` variable
- `${:CB-PREFIX}/ALLOC-COUNTER-CFFI` and `${:CB-PREFIX}/FREE-COUNTER-CFFI` functions
- `${:CB-PREFIX}/COUNTER-CFFI` and `(SETF ${:CB-PREFIX}/COUNTER-CFFI)` functions
- `${:CB-PREFIX}/INCR-COUNT` function
- `${:CB-PREFIX}/CB` and `(SETF ${:CB-PREFIX/CB)` functions
- `${:CB-PREFIX}/DEL-CB` function
- `${:CB-PREFIX}/REGIST-CB` and `${:CB-PREFIX}/UNREGIST-CB` functions
- `${:CB-PREFIX}/ROUTE-BY-CLIENT-DATA` function

Let's take an example, where the `:CB-PREFIX` is `\"CALLME\"` :

- `CALLME-CB-COUNTER-T` will be a CFFI typedef, usually integer types, like `:UINT64`,
- `*CALLME-CB-COUNTER*` keep track of last issued \"callback number\", this number is used to tag passed to C API and passed back from C API callbacks as \"`clientData`\" or \"closure\". This tag is used to find matching Lisp closure to invoke.

- `(CALLME/ALLOC-COUNTER-CFFI counter)` and `(CALLME/FREE-COUNTER-CFFI returned-counter-ptr-from-alloc-counter-cffi)` functions are used to allocate/deallocate heap memory for counter numbers. (also assigns `counter`)
- `(CALLME/COUNTER counter-ptr)` and `(SETF (CALLME/COUNTER counter-ptr) counter)` reads and writes from/to heap allocated C variable `counter-ptr` with `counter`.

- `(CALLME/INCR-COUNT)` simply returns new counter number.

TODO



"

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
         (defvar ,lock-defvar (bt2:make-lock :name ,lock-name))

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
             (when (,del-closure-fname counter)
               (,free-counter-cffi-fname client-data))))

         (defun ,route-by-client-data-fname (client-data &rest args)
           (let* (
                  ;;(%dbg-client-data (format t "client-data: ~a~%" client-data))
                  (counter (,counter-cffi-fname client-data))
                  ;;(%dbg-counter (format t "counter: ~a~%" counter))
                  (cb (,closure-fname counter))
                  ;;(%dbg-cb (format t "cb: ~a~%" cb))
                  )
             (assert cb (cb)
                     "Callback closure not registered? (~a / ~a)"
                     ,cb-prefix counter)
             ;;
             (unwind-protect (apply cb args)
               (if ,one-off?
                   (,unregist-fname client-data)
                   t
                   ))))
         ))))

