#lang racket
(require "./chains.ss")

(define G1
  (build-grammar 
   '((X -> ((E s X) (E s E)))
     (E -> ((e)))
     )
   '(X E)))


(define G2
  (build-grammar 
   '((Y -> ((Y s E) (E s E)))
     (E -> ((e))))
   '(Y E)))


(define grammchains-G1
  (compute-xchains G1 'X 20))

(show-chains grammchains-G1)


(define simple-chains-G2
  (compute-chains G2 'Y 100))


(show-conflicts (find-conflicts grammchains-G1
                                simple-chains-G2))

(sufficient-conditions simple-chains-G2)

(sufficient-conditions (set '((a) (b c d) (e))
                            '((b) (c d) (e))
                            '((b) (c) (d))
                            ))
