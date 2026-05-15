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



(defun link/alloc-var (var-type &key default-val)
  (assert (link/var-type? var-type) (var-type))
  ;;
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (case cffi-type
      ('(:pointer :char) (link/alloc-var-str default-val))
      (t                 (cffi:foreign-alloc
                          cffi-type
                          :initial-contents default-val)))))

(defun link/alloc-var-str (default-str)
  (if default-str
      (str->tcl-alloced-charp default-str)
      (cffi:make-pointer (cffi:pointer-address (cffi:null-pointer)))))


(defun link/free-var (ptr var-type)
  (assert (link/var-type? var-type) (var-type))
  (let ((cffi-type  (link/var-cffi-type var-type)))
    (case cffi-type
      ('(:pointer :char) (link/free-var-str ptr))
      (t                 (cffi:foreign-free ptr)))))

(defun link/free-var-str (ptr)
  (when (and (not (null ptr))
             (not (cffi:null-pointer-p ptr)))
    (tcl-free ptr)))


(defun link/alloc-array (var-type size &key default-vals)
  (assert (link/array-type? var-type) (var-type))
  ;;
  (let* ((cffi-type  (link/array-cffi-type var-type)))
    (cffi:foreign-alloc cffi-type :count size
                                  :initial-element default-vals)))

(defun link/free-array (ptr var-type)
  (declare (ignore var-type))
  (cffi:foreign-free ptr))




(defun link/+var (var-name var-type &key readonly? default-val)
  (assert (link/var-type? var-type) (var-type))
  (let ((var-ptr  (link/alloc-var var-type :default-val default-val))
        (flags    (if readonly?
                      (logior +tcl-link-read-only+ var-type)
                      var-type)))
    ;;
    (do+chk (tcl-link-var) *tcl-interp* var-name var-ptr flags)
    var-ptr))


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
   (array-size :reader array-size
               :initarg :array-size
               :initform nil)
   (var-type :initarg :var-type
             :reader var-type)
   (readonly? :initarg :readonly?
              :initform nil
              :reader readonly?)
   (default-val :initarg :default-val
                :initform nil
                :reader default-val)
   ))



(defmethod initialize-instance :before
    ((var-link <tcl-var-link>) &rest args)
  (assert (member :tcl-name args) (args))
  (assert (member :var-type args) (args)))



(defmethod initialize-instance :after
    ((var-link <tcl-var-link>) &key)
  (with-slots (ptr) var-link
    (setf ptr (if (array-size var-link)
                  (link/+array (tcl-name var-link)
                               (var-type var-link)
                               (array-size var-link)
                               :readonly? (readonly? var-link)
                               :default-vals (default-val var-link))
                  (link/+var   (tcl-name var-link)
                               (var-type var-link)
                               :readonly? (readonly? var-link)
                               :default-val (default-val var-link))))))


(defmethod print-object ((var-link <tcl-var-link>) stream)
  (print-unreadable-object (var-link stream :type t :identity t)
    (format stream
            "ptr:~a  tcl-name:~a  array-size:~a  var-type:~a  readonly?:~a default-val:~a"
            (ptr var-link) (tcl-name var-link) (array-size var-link)
            (var-type var-link) (readonly? var-link) (default-val var-link))))


(defmethod destroy ((var-link <tcl-var-link>))
  (link/-unlink (tcl-name var-link))
  (if (array-size var-link)
      (link/free-array (ptr var-link)
                       (var-type var-link))
      (link/free-var   (ptr var-link)
                       (var-type var-link)))
  ;;
  (with-slots (ptr) var-link
    (setf ptr (cffi:null-pointer))))


(defmethod linked-value ((var-link <tcl-var-link>) &key array-index)
  ;; TODO
  )
  

;; TODO get/var
;; TODO get/array

;; TODO setf/var
;; TODO setf/array


