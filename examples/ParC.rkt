#lang racket
(require "./chains.ss")
  
(define G0 (build-grammar
                       '((S -> ((if < E > E)))
                         (E -> ((E + T) (a) (< E >)))
                         (T -> ((a) (< E >)))
                         )
                       '(S T E)))


(define G0Modif (build-grammar
                  '((S -> ((if < E > < E >)
                           (if < E > a + T)
                           (if < E > a x T)
                           (if < E > a + E)
                           (if < E > a)
                           (if < E > < E > + T)
                           (if < E > < E > x T)
                           (if < E > < E > + E)))
                    (E -> ((T + E) (a) (< E >)))
                    (T -> ((a) (< E >) (a x T) (< E > x T) ))
                    )
                  '(S T E)))




(define H 1)

(define grammchains (grammatical-chains G0Modif 'S H 18 ))


(show-chains grammchains)

(define simple-chains (chains-as-set (chains G0Modif 'S H 100)))
                         
(parallel-find+show-conflicts grammchains simple-chains)
