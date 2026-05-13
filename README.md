# tclish

> Much more Lispy(tm) Tcl/Tk 9.0

* VERSION: 0.0.1

* Currenctly only supports SBCL and tested under:
   * SBCL 2.6.4 / Linux x86_64
   * libtcl9.0 (9.0.1+dfsg-2)
   * libtk9.0 (9.0.1-3)

* Suggestions, Patches, Issues and PRs are Welcomed.

...More hacks will be come, anytime soon. ;-)



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
