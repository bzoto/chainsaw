#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y) (Z)))
     (X -> ((a A b g)))
     (A -> ((c d C)))
     (C -> ((f)))
     (Y -> ((a B b h)))
     (B -> ((c E d)))
     (E -> ((e)))
     (Z -> ((e D g)))
     (D -> ((d b)))
     )
   '(S X Y Z A B C D E)))



(define H 1)

(define grammchains (grammatical-chains G1 'S H 15))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'S H 100)))
(parallel-find+show-conflicts grammchains simple-chains)


;; Should be: A ~ B
(define Gmax
  (build-grammar 
   '((S -> ((X) (Y) (Z)))
     (X -> ((a A b g)))
     (A -> ((c d C)))
     (C -> ((f)))
     (Y -> ((a A b h)))
     (A -> ((c E d)))
     (E -> ((e)))
     (Z -> ((e D g)))
     (D -> ((d b)))
     )
   '(S X Y Z A C D E)))

(define mgrammchains (grammatical-chains Gmax 'S H 15))
(show-chains mgrammchains)
(define msimple-chains (chains-as-set (chains Gmax 'S H 100)))
(parallel-find+show-conflicts mgrammchains msimple-chains)
