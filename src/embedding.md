

### Embedding Tcl/Tk Interpreter in Lisp application

```lisp
(app-main
    (:tk-init? t
     :tk-main-loop? t)

    (eval-tcl "button .btn -text {<esc>:q!} -command {destroy .}"
              "pack .btn"))
```

* [ZipFS](https://www.tcl-lang.org/man/tcl8.7/TclCmd/zipfs.html)
  supports builtin, your Lisp executable image is the new
  [Starkit](https://wiki.tcl-lang.org/page/Starkit) ⭐
* (*NOTE* Tk DSL will be available soon, I'm working on it😅)

