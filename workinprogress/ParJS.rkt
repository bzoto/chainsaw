#lang racket
(require "./chains.ss")
  
(define G0 (build-grammar
                       '((S -> ((if < E > E) 
                                (if < E > A)))
                         (A -> ((A < E >) 
                                (< E >)
                                (A + T) 
                                (a)))
                         (E -> ((E + T) 
                                (a) 
                                (< E >)
                                (< A > )))
                         (T -> ((a) 
                                (< E >)
                                (< A > )))
                         )
                       '(S T E A)))


(define G1 (build-grammar
                       '((S -> ((if < E > A) 
                                (if < E > a + T)
                                (if < E > a x T)
                                (if < E > a + E)
                                (if < E > a)
                                (if < E > a + A)
                                (if < E > a x A)
                                (if < E > A a + A)
                                (if < E > A a x A)
                                (if < E > A a)
                                ))
                         (A -> ((< E > A) (< E >)))
                         (E -> ((T + E) (a) (< E >) (< A > )))
                         (T -> ((a) (< E >) (< A > ) (a x T) (< E > x T) ))
                         )
                       '(S T E A)))



(define XCs (compute-xchains G1 'S 20))
(show-chains XCs)

(define Cs (compute-chains G1 'S 100))
                         
(parallel-find+show-conflicts XCs Cs)
