#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E - T) (T * F) (a) (- a)))
                         (T -> ((T * F) (a) (- a)))
                         (F -> ((a) (- a))))
                       '(E T F)))

(define G2 (build-grammar
                       '((E -> ((E - T) (T * a)(a)(- a)(T * - a)))
                         (T -> ((a * T) (a) (- a) (- a * T))))
                       '(E T)))

(define G3 (build-grammar
                       '((E -> ((E - T) (T * P) (T * N) (a) (- a)))
                         (T -> ((T * P) (T * N) (a) (- a)))
                         (P -> ((a)))
                         (N -> ((- a))))
                       '(E T P N)))


(define grammchains (grammatical-chains G3 'E 1 10))
(show-chains grammchains)

(define simple-chains (chains-as-set (chains G3 'E 1 100)))


(parallel-find+show-conflicts 
 grammchains
 simple-chains
 )

;(sufficient-conditions simple-chains)
