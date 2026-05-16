(defsystem "tclish-examples"
  :version "0.0.1"
  :author "Jonghyouk Yun"
  :mailto "ageldama@gmail.com"
  :license "MIT"
  :depends-on (:tclish)
  :components ((:module "examples"
                :serial t
                :components
                ((:file "01-tk-msgbox")
                 (:file "02-def-cmd")
                 (:file "03-cmd-with-evtq")
                 (:file "04-redir-stdout")
                 (:file "05-tk-main-loop")
                 (:file "06-def-cmd-in-ns")
                 (:file "07-ensemble")
                 (:file "08-apply-lambda")
                 (:file "09-eval-tcl-result")
                 (:file "10-tcl-var")
                 (:file "11-link-var-uint")
                 (:file "12-link-var-string")
                 (:file "13-link-array-uint")
                 ))
               )
  :description "Examples of Much more Lispy(tm) Tcl/Tk 9.0"
  )
