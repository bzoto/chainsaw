#lang racket
(require "./chains.ss")

(define G1
  (build-grammar
   '(
     (($ . $) -> ((b (b . b) b)  (($ . a) a (a . a) a)))
     ((b . b) -> ((b (b . b) b)  (($ . a) a (a . a) a)))
     ((a . a) -> ((b (b . b) b)  (($ . a) a (a . a) a)))
     (($ . a) -> ((b (b . b) b)  (($ . a) a (a . a) a)))
     )
   '(($ . $) (b . b) (a . a) ($ . a))))



(define grammchains (grammatical-chains G1 '($ . $) 1 20))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 '($ . $) 1 100)))

(show-conflicts
 (find-conflicts grammchains
                simple-chains
                ))

(sufficient-conditions  simple-chains)

