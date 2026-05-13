# tclish

> Much more Lispy(tm) Tcl/Tk 9.0

* VERSION: 0.0.1

* Currenctly only supports SBCL and tested under:
   * SBCL 2.6.4 / Linux x86_64
   * libtcl9.0 (9.0.1+dfsg-2)
   * libtk9.0 (9.0.1-3)

* Suggestions, Patches, Issues and PRs are Welcomed.

...More hacks will be come, anytime soon. ;-)



## Examples

Write your new Tcl/Tk commands in Lisp:
```lisp
(create-command
    (:interp *tcl-interp* :name "AWESOME_PROC")
    (format t "HI!: ~a ~a~%" interp args)
    :I-AM-A-RESULT-VALUE)
```


1. [`tk_messageBox`](./examples/01-tk-msgbox.lisp)
1. [Create Tcl command with ease](./examples/02-create-command.lisp)
1. [Threadin in Lisp-side, Tcl Event Queue](./examples/03-cmd-with-evtq.lisp)
1. *Unstable* [Redirecting Tcl standard channel to Lisp stream](./examples/04-redir-stdout.lisp)
1. [Tk "main-loop"](./examples/05-tk-main-loop.lisp)


```lisp
> (ql:quickload :tclish-examples)
> (tclish/examples/05-tk-main-loop:main-tk-main-loop)
```




## Dependencies

* [raw-cffi-tcl9](https://github.com/ageldama/raw-cffi-tcl9)


## Installation
* Put a symlink of the `.asd` file into your
  `$HOME/common-lisp`-directory, and:
  ```lisp
  > (asdf:clear-configuration)
  > (ql:quickload :tclish)
  ```




## License

[Licensed under the MIT License](https://opensource.org/license/mit)

Please read the [./LICENSE](./LICENSE)
