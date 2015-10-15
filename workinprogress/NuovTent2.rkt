#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((Z a Y1 c X)))
     (Z -> ((b b g Z f a a) (b b g f a a)))
     (X -> ((c c f X g d d)(c c f g d d)))
     (Y1 -> ((a Y c)(a a Y c c)))
     (Y -> ((a a Y c c) (a a c c)))
     )

   '(S X Y Y1 Z)))


(define grammchains (grammatical-chains G1 'S 1 40))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 1 100))
                          ))
