




### Comparison Table

A comparasion table with other great Tcl/Tk libraries for Common Lisp:

|                  | Points                                                                            |
|-----------------:|:----------------------------------------------------------------------------------|
|       **tclish** | based on complete Tcl/Tk 9.0 / CFFI Binding : `raw-cffi-tcl9`                     |
|                  | 😅 Need to be careful with DLLs, FFIs.                                            |
|                  | 🐥 Just born yesterday                                                            |
|                  | 🐣 Doesn't even have a proper Tk abstrations, (not yet, working on it)            |
|                  | 😍 Freely access internals of Tcl/Tk (a bit?)                                     |
|                  | 😅 Not widely tested (not yet)                                                    |
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




