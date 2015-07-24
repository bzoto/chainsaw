#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X1) (X2)(X3)(X4)(Y1)(Y2)(Y3)(Y4)))
     (X1 -> ((d d A c H d d)))
     (X2 -> ((d d A c F d d)))
     (X3 -> ((d d E c F d d)))
     (X4 -> ((d d E c H d d))) 
     (A -> ((a A b) (a b)))
     (H -> ((h H l)(h l)))
     (E -> ((a E e) (a e)))
     (F -> ((f F l)(f l)))
     (Y1 -> ((d d E c D d d)))
     (Y2 -> ((d d A c D d d)))
     (Y3 -> ((d d B c F d d)))
     (Y4 -> ((d d B c H d d)))
     (D -> ((h l D d d )(h l d d)))
     (B -> ((d d B a b)(d d a b)))
     )

   '(S X1 X2 X3 X4 Y1 Y2 Y3 Y4 A H D B E F)))



 
(define G2
  (build-grammar 
   '((S -> ((X1) (X2)(X3)(X4)(Y1)(Y2)(Y3)(Y4)))
     (X1 -> ((d d A c h h H l l d d)))
     (X2 -> ((d d A c F d d)))
     (X3 -> ((d d E c F d d)))
     (X4 -> ((d d E c h h H l l d d))) 
     (A -> ((a A b) (a b)))
     (H -> ((h H l)(h l)))
     (E -> ((a E e) (a e)))
     (F -> ((f F l)(f l)))
     (Y1 -> ((d d E c h l D d d d d)))
     (Y2 -> ((d d A c h l D d d d d)))
     (Y3 -> ((d d B c F d d)))
     (Y4 -> ((d d B c H d d)))
     (D -> ((h l D d d )(h l d d)))
     (B -> ((d d B a b)(d d a b)))
     )

   '(S X1 X2 X3 X4 Y1 Y2 Y3 Y4 A H D B E F)))
   
   (define grammchains (grammatical-chains G1 'S 1 30))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 1 100))
                          ))
