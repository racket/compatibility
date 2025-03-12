#lang info
(define collection 'multi)
(define deps '("base"
               "scribble-lib"
               "compatibility-lib"
               "pconvert-lib"
               "sandbox-lib"
	       "compiler-lib"
               "gui-lib"
               "racket-doc"
               "pconvert-doc"))

(define pkg-desc "documentation part of \"compatibility\"")

(define pkg-authors '(eli mflatt robby samth))
(define build-deps '("data-doc"
                     "mzscheme-doc"
                     "scheme-lib"
                     "scheme-doc"))
(define implies '("pconvert-doc"))
(define update-implies '("compatibility-lib"))

(define license
  '(Apache-2.0 OR MIT))
