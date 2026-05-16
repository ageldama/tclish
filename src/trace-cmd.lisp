(in-package #:tclish)


(def-tcl-callback-pattern
    :cb-prefix "trace-cmd"
  :one-off? nil
  :counter-cffi-type :uint64)

