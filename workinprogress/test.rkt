#lang racket
(require "./chains.ss")

(define G1
  (build-grammar 
   '((S -> ((a A b B c)))
     (A -> ((d1)(d2)))
     (B -> ((e1)(e2)))
     )
   '(S A B)))

(define H 1)


(define grammchains (grammatical-chains G1 'S H 10))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'S H 100)))
(parallel-find+show-conflicts grammchains simple-chains)


(define max (maxg G1 'S 100))
(define mgrammchains (grammatical-chains max 'S H 15))
(show-chains mgrammchains)
(define msimple-chains (chains-as-set (chains max 'S H 100)))
(parallel-find+show-conflicts mgrammchains msimple-chains)

