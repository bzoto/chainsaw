#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((N -> ((b N b ) (a N a ) (N a a) (b b) (a a)))
     )
   '(N)))



(define grammchains (grammatical-chains G1 'N 1 20))
(show-chains grammchains)

(define simple-chains (chains-as-set (chains G1 'N 1 100)))


(show-conflicts
 (find-conflicts grammchains
                 simple-chains
                 ))

(sufficient-conditions  simple-chains)
