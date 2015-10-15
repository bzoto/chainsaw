#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((s s E v E) (v) (s v v) (s v E))))
                       '(E)))



(define grammchains (grammatical-chains G1 'E 1 10))
(show-chains grammchains)
(define simple (chains-as-set (chains G1 'E 1 100)))


(parallel-find+show-conflicts 
 grammchains
 simple
 )

(sufficient-conditions simple)
