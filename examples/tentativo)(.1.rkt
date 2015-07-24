#lang racket
(require "./chains.ss")
  
(define G0 (build-grammar
                       '((S -> ((if < E > < E >)(if < E > E)))
                         (E -> ((E + T) (a) (< E >)))
                         (T -> ((a) (< E >)))
                         )
                       '(S T E)))


(define G1 (build-grammar
                       '((S -> ((if < E > < E >)(if < E > a + T)(if < E > a x T)(if < E > a + E)(if < E > a)))
                         (E -> ((T + E) (a) (< E >)))
                         (T -> ((a) (< E >) (a x T) (< E > x T) ))
                         )
                       '(S T E)))


(define G2 (build-grammar
             '((S -> ( (if A < E >) 
                       (if A a - - a )
                       (if A a - - a T )
                       (if A a - a )
                       (if A a )
                       (if < E > - a )
                       (if < E > - a T )
                       (if A < E > - - a )
                       (if A a - < E > )
                       (if A < E > - < E > )
                       (E) ))
               (A -> ((< E >)))
               (E -> ((E - - a T)
                      (E - a T)
                      (E - a) 
                      (E - - a) 
                      (a) 
                      (- a)
                      (- a T)
                      (a T)
                      (E - - < E > T)
                      (E - < E > T)
                      (E - < E >) 
                      (E - - < E >) 
                       
                      (- < E >)
                      (- < E > T)
                      ))
               
               (T -> (
                      (x - a T)
                      (x a T)
                      (x - a)
                      (x a)
                      (x - < E > T)
                      (x < E > T)
                      (x - < E >)
                      (x < E >)))
               )
             '(E T A S)))

(define H 1)

(define grammchains (grammatical-chains G2 'S H 15))


(show-chains grammchains)

(parallel-find+show-conflicts
 grammchains
 (chains-as-set (chains G2 'S H 100))
 )
