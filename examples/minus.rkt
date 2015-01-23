#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E - T) (T * F) (a) (- a)))
                         (T -> ((T * F) (a) (- a)))
                         (F -> ((a) (- a))))
                       '(E T F)))



(define grammchains (grammatical-chains G1 'E 2 10))


(show-chains grammchains)

;(show-conflicts
          (find-conflicts-par-chan grammchains
                          (chains-as-set (chains G1 'E 2 100))
                          2
                          2)
;)
