#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((a S b b) ( a S b A b ) (a b A b) (a b b)))
     (A -> ((a A b) (a b)))
     )
   '(S A)))

(define G2
  (build-grammar 
   '((S -> ((A) (Z)))
     (A -> ((a B c)))
     (B -> ((a b)))
     (Z -> ((a Z b b) (a b b)))
     )
   '(S Z A B)))

(define G3
  (build-grammar 
   '((S -> (($|AC|$) ($|ABB|$)))
     ($|AC|$ ->  ((a A|AB|C c)  (a c)))
     ($|ABB|$ -> ((a A|ABB|B b b) (a b b)))
     (A|ABB|B -> ((a A|ABB|B b b) (a b b)))
     (A|AB|C -> ((a b)))
     )
   '(S A|AB|C A|ABB|B $|AC|$ $|ABB|$)))

(define H 1)

(define max (maxg G2 'S 100))
(define grammchains (grammatical-chains G2 'S H 15 ))
(show-chains grammchains)
(displayln "-------")
(define grammchains-max (grammatical-chains max 'S H 15 ))
(show-chains grammchains-max)

(show-conflicts
          (find-conflicts grammchains-max
                          (chains-as-set (chains max 'S H 100))
                          ))

