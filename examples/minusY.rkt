#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
             '((E -> ((E - - a T)
                      (E - a T)
                      (a)
                      (- a)
                      (- a x a)
                      (a x a)
                      (- a x -a)
                      (a x -a)))
               (T -> (
                      (x - a x a T)
                      (x a x a T)
                      (x - a x -a T)
                      (x a x -a T)
                      (x - a x a)
                      (x a x a)
                      (x - a x -a)
                      (x a x -a))))
             '(E T)))
                      
                   
                  

(define grammchains (grammatical-chains G1 'E 1 25 5))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'E 1 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)



;(sufficient-conditions simple-chains)


