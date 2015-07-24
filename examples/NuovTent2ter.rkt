#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((Z a Y c X)))
     (Z -> ((b b g Z f a a) (b b g f a a)))
     (X -> ((c c f X g d d)(c c f g d d)))
     (Y -> ((a Y c)(a c)))
     )

   '(S X Y Z)))

(define G2
  (build-grammar 
   '((S -> ((b b g Z a Y1 c X g d d)))
     (Z -> ((b b g Z a a f)(b b g f a a f)))
     (X -> ((f c c X g d d)(f c c f g d d)))
     (Y1 -> ((a Y c)))
     (Y -> ((a Y c)(a c)))
     )

   '(S X Y Y1 Z)))


(define grammchains (grammatical-chains G2 'S 1 40))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G2 'S 1 100))
                          ))
