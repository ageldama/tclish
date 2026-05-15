(in-package :tclish)




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



(defun link/alloc-var (var-type &key initial-element)
  (assert (link/var-type? var-type) (var-type))
  ;;
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (cond
      ((equal cffi-type
              '(:pointer :char))
       (link/alloc-var-str initial-element))
      (t (let ((alloc-args (list cffi-type)))
           (when initial-element
             (alexandria:nconcf alloc-args
                                (list :initial-element
                                      initial-element)))
           (apply #'cffi:foreign-alloc alloc-args))))))


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
    (case cffi-type
      ('(:pointer :char) (link/free-var-str ptr))
      (t                 (cffi:foreign-free ptr)))))

(defun link/free-var-str (ptr)
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
      (t
       (cffi:mem-ref ptr cffi-type)))))


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


(defun link/write-var-str (ptr new-value)
  ;; 현재값이 있다면 해제:
  (let ((char* (cffi:mem-ref ptr :intptr)))
    (unless (eq char* (cffi:pointer-address (cffi:null-pointer)))
        (tcl-free (cffi:make-pointer char*))))
  ;; 새로 할당해서 변경:
  (setf (cffi:mem-ref ptr :intptr)
        (cffi:pointer-address (str->tcl-alloced-charp new-value))))









(defun link/alloc-array (var-type size &key default-vals)
  (assert (link/array-type? var-type) (var-type))
  ;;
  (let* ((cffi-type  (link/array-cffi-type var-type))
         (alloc-args (list cffi-type :count size)))
    ;; FIXME
    (when default-vals (alexandria:nconcf alloc-args
                                          (list :initial-contents default-vals)))
    (apply #'cffi:foreign-alloc alloc-args)))

(defun link/free-array (ptr var-type)
  (declare (ignore ptr var-type)))






(defun link/+var (var-name var-type &key readonly? initial-element)
  (assert (link/var-type? var-type) (var-type))
  (let ((var-ptr  (link/alloc-var var-type :initial-element initial-element))
        (flags    (if readonly?
                      (logior +tcl-link-read-only+ var-type)
                      var-type)))
    ;;
    (do+chk (tcl-link-var) *tcl-interp* var-name var-ptr flags)
    var-ptr))


;; FIXME
#+nil
(defun link/+array (array-name var-type size &key readonly? default-vals)
  (assert (link/array-type? var-type) (var-type))
  (assert (> size 0) (size))
  ;;
  (let ((array-ptr  (link/alloc-array var-type size
                                      :default-vals default-vals))
        (flags      (if readonly?
                        (logior +tcl-link-read-only+ var-type)
                        var-type)))
    ;;
    (do+chk (tcl-link-array)
            *tcl-interp* array-name array-ptr flags size)
    array-ptr))







(defclass <tcl-var-link> ()
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
    ((var-link <tcl-var-link>) &rest args)
  (assert (member :tcl-name args) (args))
  (assert (member :var-type args) (args)))


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

(defmethod update ((var-link <tcl-var-link>))
  (link/update (tcl-name var-link)))

(defmethod destroy ((var-link <tcl-var-link>))
  (link/-unlink (tcl-name var-link))
  (link/free-var (ptr var-link) (var-type var-link))
  (with-slots (ptr) var-link (setf ptr nil)))



(defmethod linked-value ((var-link <tcl-var-link>))
  (link/read-var (ptr var-link) (var-type var-link)))

(defmethod (setf linked-value) (new-value (var-link <tcl-var-link>))
  (link/write-var (ptr var-link) (var-type var-link) new-value))




;; TODO get/array
;; TODO setf/array


