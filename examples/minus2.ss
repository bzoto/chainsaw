#lang racket
(require "./chains.ss")
  
(define G1
'((E -> ((E - T) (T * F) (a) (M a)))
  (T -> ((T * F) (a) (M a)))
  (F -> ((a) (M a)))
  (M -> ((-) (M -)))))


(chains (build-grammar G1 '(E T F M))  
        'E    ; axiom
        2     ; context size 
        100)  ; number of steps

