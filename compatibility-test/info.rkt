#lang info
(define collection 'multi)
(define deps '("base"
               "racket-test"
               "compatibility-lib"
               "drracket-tool-lib"
               "rackunit-lib"
               ["pconvert-lib" #:version "1.1"]))

(define pkg-desc "tests for \"compatibility-lib\" and pconvert")

(define pkg-authors '(mflatt))
