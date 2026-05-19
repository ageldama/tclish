
### Extending Tcl/Tk in Lisp

```lisp
(def-cmd ("AWESOME_PROC")
    (format t "HI!: ~a ~a~%" interp args)
    :I-AM-A-RESULT-VALUE)

(eval-tcl "AWESOME_PROC"
          "puts {WAS Awesome}")
```

