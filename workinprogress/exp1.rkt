#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E + T) (F)))
                         (T -> ((T * F) (e)))
                         (F -> ((e))))
                       '(E T F)))


(define Xc (compute-xchains G1 'E 14 4))
(show-chains Xc)

(define Sc (compute-chains G1 'E 100))





(parallel-find+show-conflicts Xc Sc)


;(show-conflicts (find-conflicts Xc Sc))
