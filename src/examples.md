
## Examples


```lisp
> (ql:quickload :tclish-examples)
> (tclish/examples/05-tk-main-loop:main-tk-main-loop)
```

1. [`tk_messageBox`](./examples/01-tk-msgbox.lisp)
   1. Very basic usage of `app-main` and `eval-tcl`.

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

1. [Applying Tcl Lambda](./examples/08-apply-lambda.lisp)
   1. Invoking callback (Tcl lambda list) from custom command written
      in Lisp.

1. [Getting result value from Tcl code evaluations](./examples/09-eval-tcl-result.lisp)

1. [Getting, Setting, and Unsetting Tcl variables with Tcl namespaces](./examples/10-tcl-var.lisp)

1. Auto-Synchronised Variables between Tcl and Lisp through Link
   Var/Array:
   1. [Link Unsigned Integer Variable](./examples/11-link-var-uint.lisp)
   1. [Link String Variable](./examples/12-link-var-string.lisp)
   1. [Link Fixed-Size Array](./examples/13-link-array-uint.lisp)

1. [Interpreter Cleanup Callback](./examples/14-call-when-deleted.lisp)

1. *Unstable* [Tracing Tcl Variables at Lisp](./examples/15-trace-var.lisp)

1. *Unstable* [Tracing Tcl Commands at Lisp](./examples/16-trace-cmd.lisp)

1. A good base to build a stepping debugger and performance profiler
   on:
   - [Interpreter Trace](./examples/17-interp-trace.lisp)

