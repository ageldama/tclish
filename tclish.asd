(defsystem "tclish"
  :version "0.0.1"
  :author "Jonghyouk Yun"
  :mailto "ageldama@gmail.com"
  :license "MIT"
  :depends-on (
               :uiop
               :cffi
               :alexandria
               :iterate
               :str
               :raw-cffi-tcl9
               )
  :components ((:module "src"
                :serial t
                :components
                (
                 (:file "tclish-cffi")
                 (:file "tclish")
                 (:file "value-juggling")
                 (:file "apply-lambda")
                 (:file "do+chk")
                 (:file "zipfs")
                 (:file "create-cmd")
                 (:file "evtq")
                 (:file "misc")
                 (:file "tclish-redir-to-outstream-chan")
                 ))
               )
  :description "Much more Lispy(tm) Tcl/Tk 9.0"
  )
