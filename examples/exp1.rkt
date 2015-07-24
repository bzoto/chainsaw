#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E + T) (T * F) (e)))
                         (T -> ((T * F) (e)))
                         (F -> ((e))))
                       '(E T F)))


(define grammchains (grammatical-chains G1 'E 1 10))
(show-chains grammchains)

(define simple-chains (chains-as-set (chains G1 'E 1 100)))


(parallel-find+show-conflicts 
 grammchains
 simple-chains
 )

;(sufficient-conditions simple-chains)
