#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((T - E) (F * T) (a) (- A)))
                         (T -> ((F * T) (a) (- A)))
                         (F -> ((a) (- A)))
                         (A -> ((a))))
                       '(E T F A)))




(define grammchains (grammatical-chains G1 'E 2 15))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'E 2 100)))

(time
 
(parallel-find+show-conflicts
 grammchains
 simple-chains
 )

)

(sufficient-conditions simple-chains)
