(in-package :tclish)




(defmacro nconcf-if (place pred-form list-to-nconc)
  `(when ,pred-form
     (alexandria:nconcf ,place ,list-to-nconc)))


(defun remhash-by-value (val ht &key (test #'eq))
  (let ((keys-to-delete (iter (for (k v) in-hashtable ht)
                          (when (funcall test val) (collect k)))))
    (dolist (k keys-to-delete)
      (remhash k ht))))




(eval-when (:compile-toplevel :load-toplevel :execute)
  #+nil (pushnew :tclish-safer-alternative *features*)
  )




(defun link/update  (var-name)
  (tcl-update-linked-var *tcl-interp* var-name))

(defun link/-unlink (var-name)
  (tcl-unlink-var *tcl-interp* var-name))




(defun link/common-type? (type)
  (member type
          (list +tcl-link-int+ +tcl-link-uint+ +tcl-link-char+ +tcl-link-uchar+
                +tcl-link-short+ +tcl-link-ushort+ +tcl-link-long+ +tcl-link-ulong+
                +tcl-link-wide-int+ +tcl-link-wide-uint+
                +tcl-link-float+ +tcl-link-double+
                +tcl-link-boolean+)))

(defun link/var-type? (var-type)
  (or (link/common-type? var-type)
      (member var-type (list +tcl-link-string+))))

(defun link/array-type? (arr-type)
  (or (link/common-type? arr-type)
      (member arr-type (list +tcl-link-chars+ +tcl-link-binary+))))


(defvar +link/common-cffi-type-plist+
  (list +tcl-link-int+       :int
        +tcl-link-uint+      :uint
        +tcl-link-char+      :char
        +tcl-link-uchar+     :uchar
        +tcl-link-short+     :short
        +tcl-link-ushort+    :ushort
        +tcl-link-long+      :long
        +tcl-link-ulong+     :ulong
        +tcl-link-wide-int+  :tcl-wide-int
        +tcl-link-wide-uint+ :tcl-wide-uint
        +tcl-link-float+     :float
        +tcl-link-double+    :double
        +tcl-link-boolean+   :boolean))

(defvar +link/var-cffi-type-plist+
  (append +link/common-cffi-type-plist+
          (list +tcl-link-string+    '(:pointer :char))))

(defvar +link/array-cffi-type-plist+
  (append +link/common-cffi-type-plist+
          (list +tcl-link-binary+    :uchar
                +tcl-link-chars+     :char)))


(defun link/var-cffi-type (var-type)
  (getf +link/var-cffi-type-plist+ var-type))

(defun link/array-cffi-type (array-type)
  (getf +link/array-cffi-type-plist+ array-type))



#+tclish-safer-alternative
(defvar *link/var-str-ht* (make-hash-table))


(defun link/alloc-var (var-type &key initial-element)
  (assert (link/var-type? var-type) (var-type))
  ;;
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (cond
      ((equal cffi-type
              '(:pointer :char))
       (link/alloc-var-str initial-element))
      (t (let ((alloc-args (list cffi-type)))
           (nconcf-if alloc-args initial-element
                      (list :initial-element initial-element))
           (apply #'cffi:foreign-alloc alloc-args))))))

#+tclish-safer-alternative
(defun link/alloc-var-str (initial-element)
  (declare (ignore initial-element))
  (gensym))

#-tclish-safer-alternative
(defun link/alloc-var-str (initial-element)
  (let ((char* (cffi:pointer-address
                (if initial-element
                    (str->tcl-alloced-charp initial-element)
                    (cffi:null-pointer)))))
    (let ((ptr (tcl-alloc (cffi:foreign-type-size :pointer))))
      (setf (cffi:mem-ref ptr :intptr) char*)
      ptr)))


(defun link/free-var (ptr var-type)
  (assert (link/var-type? var-type) (var-type))
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (cond
      ((equal cffi-type '(:pointer :char))
       (link/free-var-str ptr))
      (t (cffi:foreign-free ptr)))))

#+tclish-safer-alternative
(defun link/free-var-str (ptr)
  (remhash ptr *link/var-str-ht*))

#-tclish-safer-alternative
(defun link/free-var-str (ptr)
  (print :FREE-VAR-STR)
  (when (and (not (null ptr))
             (not (cffi:null-pointer-p ptr)))
    (let ((addr (cffi:mem-ref ptr :intptr)))
      (unless (eq addr (cffi:pointer-address (cffi:null-pointer)))
        (tcl-free (cffi:make-pointer addr))))
    ;; 맨 마지막에 자기자신(포인터변수)도 해제.
    (tcl-free ptr)))




(defun link/read-var (ptr var-type)
  (assert (link/var-type? var-type) (var-type))
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (cond
      ((equal cffi-type
              '(:pointer :char))
       (link/read-var-str ptr))
      (t (cffi:mem-ref ptr cffi-type)))))

#+tclish-safer-alternative
(defun link/read-var-str (ptr)
  (let ((tcl-var-name (gethash ptr *link/var-str-ht*)))
    (assert tcl-var-name (tcl-var-name))
    (tcl-var tcl-var-name :as :string)))

#-tclish-safer-alternative
(defun link/read-var-str (ptr)
  (cffi:foreign-string-to-lisp
   (cffi:make-pointer (cffi:mem-ref ptr :intptr))))


(defun link/write-var (ptr var-type new-value)
  (assert (link/var-type? var-type) (var-type))
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (cond
      ((equal cffi-type
              '(:pointer :char))
       (link/write-var-str ptr new-value))
      (t
       (setf (cffi:mem-ref ptr cffi-type) new-value)))))

#+tclish-safer-alternative
(defun link/write-var-str (ptr new-value)
  (let ((tcl-var-name (gethash ptr *link/var-str-ht*)))
    (assert tcl-var-name (tcl-var-name))
    (setf (tcl-var tcl-var-name :as :string) new-value)))

#-tclish-safer-alternative
(defun link/write-var-str (ptr new-value)
  ;; 현재값이 있다면 해제:
  (let ((char* (cffi:mem-ref ptr :intptr)))
    (unless (eq char* (cffi:pointer-address (cffi:null-pointer)))
        (tcl-free (cffi:make-pointer char*))))
  ;; 새로 할당해서 변경:
  (setf (cffi:mem-ref ptr :intptr)
        (cffi:pointer-address (str->tcl-alloced-charp new-value))))








(defun link/alloc-array (var-type size
                         &key initial-contents initial-element)
  (assert (link/array-type? var-type) (var-type))

  (let* ((cffi-type  (link/array-cffi-type var-type))
         (alloc-args (list cffi-type :count size)))

    (nconcf-if alloc-args initial-contents
               (list :initial-contents initial-contents))
    (nconcf-if alloc-args initial-element
               (list :initial-element initial-element))

    (apply #'cffi:foreign-alloc alloc-args)))


(defun link/free-array (ptr var-type)
  (declare (ignore var-type))
  (cffi:foreign-free ptr))


(defun link/read-array (ptr var-type index)
  (let ((cffi-type  (link/array-cffi-type var-type)))
    (cffi:mem-aref ptr cffi-type index)))

(defun link/write-array (ptr var-type index new-value)
  (let ((cffi-type  (link/array-cffi-type var-type)))
    (setf (cffi:mem-aref ptr cffi-type index) new-value)))






(defun link/+var (var-name var-type &key readonly? initial-element)
  (assert (link/var-type? var-type) (var-type))
  (let ((var-ptr  (link/alloc-var var-type :initial-element initial-element))
        (flags    (if readonly?
                      (logior +tcl-link-read-only+ var-type)
                      var-type)))
    ;;
    #+tclish-safer-alternative
    (if (eq +tcl-link-string+ var-type)
        (setf (gethash var-ptr *link/var-str-ht*) var-name)
        ;; else:
        (do+chk (tcl-link-var) *tcl-interp* var-name var-ptr flags))
    #-tclish-safer-alternative
    (do+chk (tcl-link-var) *tcl-interp* var-name var-ptr flags)
    var-ptr))


(defun link/+array (array-name var-type size
                    &key readonly? initial-element initial-contents)
  (assert (link/array-type? var-type) (var-type))
  (assert (> size 0) (size))

  (let ((array-ptr  (link/alloc-array var-type size
                                      :initial-element initial-element
                                      :initial-contents initial-contents))
        (flags      (if readonly?
                        (logior +tcl-link-read-only+ var-type)
                        var-type)))
    ;;
    (do+chk (tcl-link-array)
            *tcl-interp* array-name array-ptr flags size)
    array-ptr))







(defclass <tcl-var-link-base> ()
  ((ptr  :reader ptr
         :initform (cffi:null-pointer))
   (tcl-name   :reader tcl-name
               :initarg :tcl-name)
   (var-type :initarg :var-type
             :reader var-type)
   (readonly? :initarg :readonly?
              :initform nil
              :reader readonly?)
   (initial-element :initarg :initial-element
                    :initform nil
                    :reader initial-element)
   ))

(defmethod initialize-instance :before
    ((var-link-base <tcl-var-link-base>) &rest args)
  (assert (member :tcl-name args) (args))
  (assert (member :var-type args) (args)))

(defmethod update ((var-link <tcl-var-link-base>))
  (link/update (tcl-name var-link)))








(defclass <tcl-var-link> (<tcl-var-link-base>)
  ())


(defmethod initialize-instance :after
    ((var-link <tcl-var-link>) &key)
  (with-slots (ptr) var-link
    (setf ptr (link/+var   (tcl-name var-link)
                           (var-type var-link)
                           :readonly? (readonly? var-link)
                           :initial-element (initial-element var-link)))))


(defmethod print-object ((var-link <tcl-var-link>) stream)
  (print-unreadable-object (var-link stream :type t :identity t)
    (format stream
            "ptr:~a  tcl-name:~a  var-type:~a  readonly?:~a  initial-element:~a"
            (ptr var-link) (tcl-name var-link)
            (var-type var-link) (readonly? var-link)
            (initial-element var-link))))

(defmethod destroy ((var-link <tcl-var-link>))
  (link/-unlink (tcl-name var-link))
  (link/free-var (ptr var-link) (var-type var-link))
  (with-slots (ptr) var-link (setf ptr nil)))



(defmethod linked-value ((var-link <tcl-var-link>))
  (link/read-var (ptr var-link) (var-type var-link)))

(defmethod (setf linked-value) (new-value (var-link <tcl-var-link>))
  (link/write-var (ptr var-link) (var-type var-link) new-value))







(defclass <tcl-array-link> (<tcl-var-link-base>)
  ((size :initarg :size
         :initform -1
         :reader size)
   (initial-contents :initarg :initial-contents
                     :initform nil
                     :reader initial-contents)
   ))


(defmethod initialize-instance :after
    ((arr-link <tcl-array-link>) &key)
  (with-slots (ptr) arr-link
    (setf ptr (link/+array (tcl-name arr-link)
                           (var-type arr-link) (size arr-link)
                           :readonly? (readonly? arr-link)
                           :initial-element (initial-element arr-link)
                           :initial-contents (initial-contents arr-link)
                           ))))

(defmethod print-object ((arr-link <tcl-array-link>) stream)
  (print-unreadable-object (arr-link stream :type t :identity t)
    (format stream
            "ptr:~a  tcl-name:~a  var-type:~a  readonly?:~a  size:~a  initial-element:~a"
            (ptr arr-link) (tcl-name arr-link)
            (var-type arr-link) (readonly? arr-link)
            (size arr-link) (initial-element arr-link))))


(defmethod destroy ((arr-link <tcl-array-link>))
  (link/-unlink (tcl-name arr-link))
  (link/free-array (ptr arr-link) (var-type arr-link))
  (with-slots (ptr) arr-link (setf ptr nil)))



(defmethod linked-value-at ((arr-link <tcl-array-link>) index)
  (link/read-array (ptr arr-link) (var-type arr-link) index))

(defmethod (setf linked-value-at) (new-value (arr-link <tcl-array-link>) index)
  (link/write-array (ptr arr-link) (var-type arr-link) index new-value))

