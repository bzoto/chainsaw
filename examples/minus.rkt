#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E - T) (T * F) (a) (- a)))
                         (T -> ((T * F) (a) (- a)))
                         (F -> ((a) (- a))))
                       '(E T F)))



(grammatical-chains-conflicts
 G1 'E 2 10
 (chains-as-set
  (chains G1 'E 2 100)))


