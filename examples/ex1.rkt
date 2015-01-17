#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y)))
     (X -> ((E s X) (E s E)))
     (Y -> ((Y s E) (E s E)))
     (E -> ((e))))
   '(S X Y E)))


(define grammchains (grammatical-chains G1 'S 2 20))

(show-chains grammchains)


(show-conflicts
 (find-conflicts grammchains
                 (chains-as-set (chains G1 'S 2 100)) 2))
