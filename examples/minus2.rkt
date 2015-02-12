#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
            '((E -> ((E - T) (T * F) (a) (M a)))
              (T -> ((T * F) (a) (M a)))
              (F -> ((a) (M a)))
              (M -> ((-) (M -))))
            '(E T F M)))



(define grammchains (grammatical-chains G1 'E 3 20))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'E 3 100)))



(show-conflicts
          (find-conflicts grammchains
                          simple-chains
                          ))

(sufficient-conditions simple-chains)
