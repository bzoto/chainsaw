#lang racket
(require "./chains.ss")
  




(define G1
  (build-grammar 
   '((S -> ((X) (Y) (Z)))
     
     (X -> ((d d A c H d d))) ;; dd a^n b^n c h^m l^m dd
     (A -> ((a A b) (a b)))
     (H -> ((h H l)(h l)))
     
     (Y -> ((d d E c D d d))) ;; dd a^n e^n c (hldd)+ dd
     (E -> ((a E e) (a e)))
     (D -> ((h l d d D)(h l d d)))
     
     (Z -> ((d d B c F d d))) ;; dd (ddab)+ c f^n l^n dd
     (B -> ((B d d a b)(d d a b)))
     (F -> ((f F l)(f l)))
     )

   '(S X Y A H D B E F Z)))

(define G2
  (build-grammar 
   '((S -> ((X) (Y) (Z)))
     
     (X -> ((d d A c H d d))) ;; dd a^n b^n c h^m l^m dd
     (A -> ((a A b) (a b)))
     (H -> ((h H l)(h l)))
     
     (Y -> ((d d E c D d d))) ;; dd a^n e^n c (hldd)+ dd
     (E -> ((a E e) (a e)))
     (D -> ((h l d d D)(h l d d)))
     
     (Z -> ((d d B c F d d))) ;; dd (ddab)+ c f^n l^n dd
     (B -> ((B d d a b)(d d a b)))
     (F -> ((f F l)(f l)))
     )

   '(S X Y A H D B E F Z)))


(define grammchains (grammatical-chains G1 'S 1 40))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 1 100))
                          ))
