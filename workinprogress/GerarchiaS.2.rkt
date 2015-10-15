#lang racket
(require "./chains.ss")
  
(define G2
  (build-grammar 
   '((S -> ((X)))
     (X -> ((b M d)))
     (M -> ((A a c C)))
     (A -> ((b A a) (h U k) (h k)))
     (U -> ((h U k) (h k)))
     (C -> ((c C d) (c d)))
     )
   '(S X A U C M)))

(define G1
  (build-grammar 
   '((S -> ((Y)))
     (Y -> ((D d H)))
     (D -> ((D d) (d)))
     (H -> ((H d d e) (B d d e)))
     (B -> ((f a a a a B c) (a c)))
     )
   '(S Y D H B)))


(define grammchains2 (grammatical-chains G2 'S 1 40 4))
(show-chains grammchains2)



(show-conflicts
          (find-conflicts grammchains2
                          (chains-as-set (chains G2 'S 1 100))
                          ))


(define grammchains1 (grammatical-chains G1 'S 3 40 4))
(show-chains grammchains1)

(show-conflicts
          (find-conflicts grammchains1
                          (chains-as-set (chains G1 'S 3 100))
                          ))
