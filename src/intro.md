
## Introduction

**`tclish`** is a Lisp wrapper around Tcl/Tk 9.0 C APIs, which
provides easier ways to interact with Tcl/Tk.

All with Easy and Powerful Lisp DSLs.

Interested? Please refer the "Examples" section below.


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


### Extending Tcl/Tk in Lisp

```lisp
(def-cmd ("AWESOME_PROC")
    (format t "HI!: ~a ~a~%" interp args)
    :I-AM-A-RESULT-VALUE)

(eval-tcl "AWESOME_PROC"
          "puts {WAS Awesome}")
```






### Comparasion Table

A comparasion table with other great Tcl/Tk libraries for Common Lisp:

|                  | Points                                                                            |
|-----------------:|:----------------------------------------------------------------------------------|
|       **tclish** | based on complete Tcl/Tk 9.0 / CFFI Binding : `raw-cffi-tcl9`                     |
|                  | 😅 Need to be careful with DLLs, FFIs.                                            |
|                  | 🐥 Just born yesterday                                                            |
|                  | 🐣 Doesn't even have a proper Tk abstrations, (not yet, working on it)            |
|                  | 😍 Freely access internals of Tcl/Tk (a bit?)                                     |
|                  | 😅 Not widely tested, documented (not yet, working on it)                         |
|                  | 😍 Focused on integrating Tcl/Tk easily with Lisp                                 |
|                  | 😍 ZipFS supports builtin                                                         |
|                  | 🤩 I love working with it!                                                        |
|                  |                                                                                   |
|          **ltk** | using `wish` subprocess + pipe communication, thus not Tcl 8.6/9.0 specific.      |
|                  | 😍 No need to worry about DLLs, FFIs.                                             |
|                  | 😍 Very easy to writing a Tk application in Lisp.                                 |
|                  | 😍 Wonderful documentation                                                        |
|                  |                                                                                   |
|       **nodgui** | based on ltk                                                                      |
|                  | 😍 More modern, ttk, megawidgets...                                               |
|                  | 😍 Actively maintained (in 2026)                                                  |
|                  | 😍 Wonderful documentation                                                        |
|                  | 🙀 More heavier than ltk with OpenGL, SDL...                                      |
|                  |                                                                                   |
| **cl-simple-tk** | CFFI binding based.                                                               |
|                  | 😍 Very easy to write a Tk application in Lisp.                                   |
|                  | 😍 Lightweight CFFI bindings, only binds minimum C functions for writing Tk code. |
|                  | (not really an expert of this library)                                            |




