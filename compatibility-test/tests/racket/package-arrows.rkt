#lang racket

(require rackunit
         drracket/check-syntax
         compatibility/package
         setup/path-to-relative
         (for-syntax setup/path-to-relative))

(define-syntax (identifier stx)
  (syntax-case stx ()
    [(_ x)
     (identifier? #'x)
     #`(let ([p (open-input-string (format "~s" 'x))])
         (port-count-lines! p)
         (set-port-next-location! 
          p
          #,(syntax-line #'x)
          #,(syntax-column #'x)
          #,(syntax-position #'x))
         (read-syntax '#,(and (path? (syntax-source #'x))
                              (path->relative-string/library (syntax-source #'x)))
                      p))]))

(define (source stx)
  (list (and (path? (syntax-source stx))
             (path->relative-string/library (syntax-source stx)))
        (syntax-line stx)
        (syntax-column stx)))

(define (expected-arrows bindings)
  (for/fold ([arrs (set)]) ([binding bindings])
    (for/fold ([arrs arrs]) ([bound (cdr binding)])
      (set-add arrs
               (list (source (car binding))
                     (source bound))))))

(define collector%
  (class (annotations-mixin object%)
    (super-new)
    (define/override (syncheck:find-source-object stx)
      stx)
    (define/override (syncheck:add-arrow start-source-obj
                                         start-left
                                         start-right
                                         end-source-obj
                                         end-left
                                         end-right
                                         actual?
                                         phase-level)
      (set! arrows 
            (set-add arrows 
                     (list (source start-source-obj)
                           (source end-source-obj)))))
    (define arrows (set))
    (define/public (collected-arrows) arrows)))

(define-namespace-anchor module-anchor)
(define module-namespace 
  (namespace-anchor->namespace module-anchor))

;; arrows for sequential let*-like scope
(let ([annotations (new collector%)])
  (define-values (add-syntax done)
    (make-traversal module-namespace #f))
  
  (define pkg-def (identifier pkg))
  (define pkg-use (identifier pkg))
  (define x-decl (identifier x))
  (define x-def1 (identifier x))
  (define x-use1 (identifier x))
  (define x-def2 (identifier x))
  (define x-use2 (identifier x))
  (define x-use3 (identifier x))
  
  (parameterize ([current-annotations annotations]
                 [current-namespace module-namespace])
    (add-syntax
     (expand #`(let ()
                 (define-package #,pkg-def (#,x-decl)
                   (define* #,x-def1 5)
                   (define* #,x-def2 (+ 1 #,x-use1))
                   #,x-use2)
                 (open-package #,pkg-use)
                 #,x-use3)))
    (done))
  
  (check-equal? (send annotations collected-arrows)
                (expected-arrows
                 (list
                  (list x-def1 x-use1)
                  (list x-def2 x-use2)
                  (list x-def2 x-use3)))))

