#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
                       '((E -> ((E - T) (T * F) (a) (- a)))
                         (T -> ((T * F) (a) (- a)))
                         (F -> ((a) (- a))))
                       '(E T F)))



(define grammchains (grammatical-chains G1 'E 3 20))


(display-list-of-strings
 (set-of-sfs->list-of-strings
  grammchains
  ))

(show-conflicts
          (find-conflicts grammchains
                (chains-as-set (chains G1 'E 3 100))))
