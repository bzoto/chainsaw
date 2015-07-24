#lang racket
(require "./chains.ss")

;; grammars for {a^n b^hn} U {a^n (b^2h c)^n}
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y)))
     (X -> ((a X b b b) (a b b b)))
     (Y -> ((a Y b b b b b b c) (a b b b b b b c))))
   '(S X Y)))


(define G2
  (build-grammar 
   '((S -> ((Y)))
     (Y -> ((a Y b b b b b b c) (a b b b b b b c))))
   '(S Y)))

(define G3
  (build-grammar 
   '((S -> ((Y c)))
     (Y -> ((a Y c b b b b b b) (a b b b b b b))))
   '(S Y)))

(define G4
  (build-grammar 
   '((S -> ((X) (Y c)))
     (X -> ((a X b b b) (a b b b)))
     (Y -> ((a Y c D b b b) (B b b b)))
     (B -> ((a b b b)))
     (D -> ((b b b))))
   '(S X Y B D)))

(define G5 ;; h=1, m=4
  (build-grammar 
   '((S -> ((X) (Y c)))
     (X -> ((a X b b b) (a b b b)))
     (Y -> ((a Y c D b b) (B b b b)))
     (B -> ((a b b b)))
     (D -> ((b b b b))))
   '(S X Y B D)))




(define grammchains (grammatical-chains G5 'S 1 35))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G5 'S 1 100))
                          ))

