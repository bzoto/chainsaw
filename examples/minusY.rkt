#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
             '((E -> ((E - - a T)
                      (E - a T)
                      (E - a) 
                      (E - - a) 
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
 (define G2 (build-grammar
             '((S -> ((E) (a T) (- a T)))
               (E -> ((E - - a T)
                      (E - a T)
                      (E - a) 
                      (E - - a) 
                      (a)
                      (- a)
                      (- a T)
                      (a T)))
               (T -> (
                      (x - a T)
                      (x a T)
                      (x - a)
                      (x a)
                      )))
             '(E T S)))                     
                   
                 
(define H 1)

(define grammchains (grammatical-chains G2 'S H 26 5))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G2 'S H 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)



;(sufficient-conditions simple-chains)


