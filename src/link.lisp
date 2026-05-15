(in-package :tclish)


(defun link/update  (var-name)
  (tcl-update-linked-var *tcl-interp* var-name))

(defun link/-unklink (var-name)
  (tcl-unlink-var *tcl-interp* var-name))




(defun link/var-type? (var-type)
  (member var-type
          '(+tcl-link-int+ +tcl-link-uint+ +tcl-link-char+ +tcl-link-uchar+
            +tcl-link-short+ +tcl-link-ushort+ +tcl-link-long+ +tcl-link-ulong+
            +tcl-link-wide-int+ +tcl-link-wide-uint+
            +tcl-link-float+ +tcl-link-double+
            +tcl-link-boolean+ +tcl-link-string+)))


(defun link/var-cffi-type (var-type)
  (let ((tcl-type->cffi-type-plist
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
                +tcl-link-boolean+   :boolean
                +tcl-link-string+    '(:pointer :char)
                )))
    (getf tcl-type->cffi-type-plist var-type)))


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



#+nil
(defun link/+var (var-name var-type &key readonly?)

  (do+chk (tcl-link-var) *tcl-interp* var-name ptr var-type)
)
