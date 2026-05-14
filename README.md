# tclish

> Much more Lispy(tm) Tcl/Tk 9.0

* VERSION: 0.0.1

* Currenctly only tested under:
   * SBCL 2.6.4 / Linux x86_64
   * libtcl9.0 (9.0.1+dfsg-2)
   * libtk9.0 (9.0.1-3)

* Suggestions, Patches, Issues and PRs are Welcomed.

...More hacks will be come, anytime soon. ;-)


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

    (eval-str "button .btn -text {<esc>:q!} -command {destroy .}"
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

(eval-str "AWESOME_PROC"
          "puts {WAS Awesome}")
```






### Comparasion Table

A comparasion table with other great Tcl/Tk libraries for Common Lisp:

|              | Points                                                                            |
|-------------:|:----------------------------------------------------------------------------------|
|   **tclish** | based on complete Tcl/Tk 9.0 / CFFI Binding : `raw-cffi-tcl9`                     |
|              | 😅 Need to be careful with DLLs, FFIs.                                            |
|              | 🐥 Just born yesterday                                                            |
|              | 🐣 Doesn't even have a proper Tk abstrations, (not yet, working on it)            |
|              | 😍 Freely access internals of Tcl/Tk (a bit?)                                     |
|              | 😅 Not widely tested, documented (not yet, working on it)                         |
|              | 😍 Focused on integrating Tcl/Tk easily with Lisp                                 |
|              | 😍 ZipFS supports builtin                                                         |
|              | 🤩 I love to working with it!                                                     |
|              |                                                                                   |
|      **ltk** | using `wish` subprocess + pipe communication, thus not Tcl 8.6/9.0 specific.      |
|              | 😍 No need to worry about DLLs, FFIs.                                             |
|              | 😍 Very easy to writing a Tk application in Lisp.                                 |
|              | 😍 Wonderful documentation                                                        |
|              |                                                                                   |
|   **nodgui** | based on ltk                                                                      |
|              | 😍 More modern, ttk, megawidgets...                                               |
|              | 😍 Actively maintained (in 2026)                                                  |
|              | 😍 Wonderful documentation                                                        |
|              | 🙀 More heavier than ltk with OpenGL, SDL...                                      |
|              |                                                                                   |
| cl-simple-tk | CFFI binding based.                                                               |
|              | 😍 Very easy to write a Tk application in Lisp.                                   |
|              | 😍 Lightweight CFFI bindings, only binds minimum C functions for writing Tk code. |
|              | (not really an expert of this library)                                            |







## Examples


```lisp
> (ql:quickload :tclish-examples)
> (tclish/examples/05-tk-main-loop:main-tk-main-loop)
```

1. [`tk_messageBox`](./examples/01-tk-msgbox.lisp)
   1. Very basic usage of `app-main` and `eval-str`.

1. [Create Tcl command with ease](./examples/02-def-cmd.lisp)
   1. Writing new Tcl command written in Lisp.
   1. Getting arguments from Tcl, returning a value, or raising an
      error.

1. [Threadin in Lisp-side, Tcl Event Queue](./examples/03-cmd-with-evtq.lisp)
   1. Utilise thread in Lisp of custom Tcl command.
   2. and How to give response in thread-safe way to the main Tcl
      thread, from background thread. (... by using
      `Tcl_ThreadQueueEvent`)

1. *Unstable* [Redirecting Tcl standard channel to Lisp stream](./examples/04-redir-stdout.lisp)
   1. Capture Tcl standard output channels (`stdout`, `stderr`) to
      Lisp streams like `*standard-output*`

1. [Tk "main-loop"](./examples/05-tk-main-loop.lisp)
   1. Creating simple Tcl/Tk application easily with `app-main`-macro.

1. [def-cmd in namespace](./examples/06-def-cmd-in-ns.lisp)
   1. How to regist custom commands within Tcl namespaces with
      `def-cmd`-macro.

1. [Tcl Ensembles + def-cmd](./examples/07-ensemble.lisp)
   1. How to group custom macros into a Tcl ensembles with
      `def-ensemble` and `def-cmd` macros.






## Dependencies

* [raw-cffi-tcl9](https://github.com/ageldama/raw-cffi-tcl9)


## Installation
* Put a symlink of the `.asd` file into your
  `$HOME/common-lisp`-directory, and:
  ```lisp
  > (asdf:clear-configuration)
  > (ql:quickload :tclish)
  ```


## Supporting

Enjoying this project? Consider supporting its growth via the Ethereum
address in [my profile](https://github.com/ageldama).



## License

[Licensed under the MIT License](https://opensource.org/license/mit)

Please read the [./LICENSE](./LICENSE)
