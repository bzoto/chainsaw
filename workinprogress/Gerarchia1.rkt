#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y)))
     (X -> ((A c C d)))
     (D -> ((D d) (d)))
     (A -> ((b A a) (r U r s) (r r s)))
     (U -> ((r U r s) (r r s)))
     (C -> ((c C d) (c d)))
     (Y -> ((r Z s H)))
     (Z -> ((r Z s) (r s)))
     (H -> ((H d) (B d)))
     (B -> ((a B c) (a c)))
     )
   '(S X D A U C Y Z H B)))


(define grammchains (grammatical-chains G1 'S 4 30))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 4 100))
                          ))
