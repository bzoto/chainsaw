#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((a S b b) (S a b b) ( a b b)))
     )
   '(S )))



(define grammchains (grammatical-chains G1 'S 1 20))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'S 1 100)))


(show-conflicts
          (find-conflicts grammchains
                          simple-chains))

(sufficient-conditions  simple-chains)
