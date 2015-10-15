#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y) (Z) (W)))

     (X -> ((d d A c h H l d d)
            (d d A c h l d d))) ;; dd a^n b^n c h^m l^m dd
     (A -> ((a A b) (a b)))
     (H -> ((h H l)(h l)))

     (Y -> ((d d E c D d d))) ;; dd a^n e^n c (hldd)+ dd
     (E -> ((a E e) (a e)))
     (D -> ((h l d d D)(h l d d)))
     
     (Z -> ((d d B c F d d))) ;; dd (ddab)+ c f^nl^n dd
     (B -> ((B d d a b)(d d a b)))
     (F -> ((f F l)(f l)))

     (W -> ((d d E1 c D d d))) ;; dd (ddae)+ c (hldd)+ dd
     (E1 -> ((E1 d d a e)( d d a e)))
     )

   '(S X Y A H D B E F Z W E1)))


(define grammchains (grammatical-chains G1 'S 1 40))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 1 100))
                          ))
