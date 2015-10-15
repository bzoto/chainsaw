#lang racket
(require "./chains.ss")
  
 (define G-minus (build-grammar
                   '((E -> ((E - - e Y)
                            (E - e Y)
                            (E - e) 
                            (E - - e) 
                            (e)
                            (- e)
                            (- e Y)
                            (e Y)))
                     (Y -> (
                            (* - e Y)
                            (* e Y)
                            (* - e)
                            (* e)
                            )))
                   '(E Y)))



(define Xc (compute-xchains G-minus 'E 14))
(show-chains Xc)

(define Cc (compute-chains G-minus 'E 100))

(parallel-find+show-conflicts Xc Cc)

