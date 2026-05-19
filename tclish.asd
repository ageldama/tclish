(defsystem "tclish"
  :version "1.0"
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
               :bordeaux-threads
               )
  :components ((:module "src"
                :serial t
                :components
                ((:file "tclish-cffi")
                 (:file "tclish")
                 (:file "callback-hellper")
                 (:file "error")
                 (:file "value-juggling")
                 (:file "interp")
                 (:file "interp-cb")
                 (:file "alias")
                 (:file "var")
                 (:file "do+chk")
                 (:file "eval")
                 (:file "apply-lambda")
                 (:file "zipfs")
                 (:file "ns")
                 (:file "create-cmd")
                 (:file "ensemble")
                 (:file "evtq")
                 (:file "link")
                 (:file "trace-var")
                 (:file "trace-cmd")
                 (:file "interp-trace")
                 (:file "cmd-info")
                 (:file "misc")
                 (:file "tclish-redir-to-outstream-chan")
                 (:file "app-main")
                 )))
  :description "Much more Lispy(tm) Tcl/Tk 9.0"
  )
