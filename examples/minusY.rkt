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
             '(;(S -> ((E) (a T) (- a T)))
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
             '(E T)))


(define H 1)

(define max (maxg G2 'E 100))
(define grammchains (grammatical-chains G2 'E H 9))
(show-chains grammchains)
(displayln " -XXXXXXXXXX-")
(define mgrammchains (grammatical-chains max 'E H 9))
(show-chains mgrammchains)

(define simple-chains (chains-as-set (chains G2 'E H 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)



;(sufficient-conditions simple-chains)


