#lang racket
(require "./chains.ss")

(define G1
  (build-grammar
   '((S -> ((b A b ) (X) ))
     (A -> ((a B a ) (a a) ))
     (B -> ((b A b ) (b b) ))
     (X -> ((X a a)  (a a)))
     )
   '(S A B X )))



(define grammchains (grammatical-chains G1 'S 1 20))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'S 1 100)))

(show-conflicts
 (find-conflicts grammchains
                simple-chains
                ))

(sufficient-conditions  simple-chains)

