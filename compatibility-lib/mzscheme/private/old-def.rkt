#lang racket/base

(require (for-syntax racket/base syntax/define))

(provide define define-syntax define-for-syntax)

(define-syntaxes (define define-syntax define-for-syntax)
  (let ([go
         (lambda (define-values-stx stx)
           (let-values ([(id rhs)
                         (normalize-definition stx #'lambda #t #f)])
             (quasisyntax/loc stx
               (#,define-values-stx (#,id) #,rhs))))])
    (values (lambda (stx) (go #'define-values stx))
            (lambda (stx) (go #'define-syntaxes stx))
            (lambda (stx) (go #'define-values-for-syntax stx)))))
