#lang info

(define collection 'multi)

(define deps '("compatibility-lib" "compatibility-doc"))
(define implies '("compatibility-lib" "compatibility-doc"))

(define pkg-desc "Libraries that implement legacy interfaces")

(define pkg-authors '(eli mflatt robby samth))

(define license
  '(Apache-2.0 OR MIT))
