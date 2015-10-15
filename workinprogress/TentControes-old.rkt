#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((T) ( Z )))
     (T -> ((h a H c r) ))
     (H -> ((M a b M)))
     (M -> ((g)))
     (Z -> ((a Q c)))
     (Q -> ((a Q b) (a b)))
     )
   '(S T Z H M Q)))

(define G2
  (build-grammar 
   '((S -> ((T) ( Z )))
     (T -> ((h a H c r) ))
     (H -> ((M a b M)(M a M b M)))
     (M -> ((g)))
     (Z -> ((a Q c)))
     (Q -> ((a Q b) (a b)))
     )
   '(S T Z H M Q)))

(define G3
  (build-grammar
   '((S -> ((a B l m n) (k H s) (f G)))
     (B -> ((e c d h)))
     (H -> ((e M l)))
     (M -> ((c d h b)))
     (G -> (( K d h b r)))
     (K -> ((a e c)))
     )
   '(S B H G M)))


(define H 1)

(define max (maxg G2 'S 100))
(define grammchains (grammatical-chains G2 'S H 12))
(show-chains grammchains)
(displayln " -XXXXXXXXXX-")
(define mgrammchains (grammatical-chains max 'S H 12))
(show-chains mgrammchains)

(define simple-chains (chains-as-set (chains G2 'S H 100)))
(define msimple-chains (chains-as-set (chains max 'S H 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)

(parallel-find+show-conflicts mgrammchains msimple-chains)



