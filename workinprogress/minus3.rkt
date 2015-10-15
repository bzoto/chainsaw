#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E - T - T) (E - T * F) (E - a) (E - - a) (E - T * a) 
                                            (T * a) (T * - a) (a) (- a)))
                         (T -> ((T * a) (T * - a) (a) (- a)))
                         (F -> ((a) (- a))))
                       '(E T F)))

(define grammchains (grammatical-chains G1 'E 3 20))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'E 3 100)))

(time
 
(parallel-find+show-conflicts
 grammchains
 simple-chains
 2
 )

)

(sufficient-conditions simple-chains)

