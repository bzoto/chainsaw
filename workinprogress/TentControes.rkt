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
   '((S -> ((A l m n) (k H s) (f G)))
     (A -> ((a B b)))
     (B -> ((e c d h)))
     (H -> ((e M l)))
     (M -> ((c d h b)))
     (G -> (( K d h b r)))
     (K -> ((a e c)))
     )
   '(S A B H G K M)))


(define G4
  (build-grammar
   '((S -> ((A l m n) (f H c R) (R c K b)))
     (A -> ((a B b)))
     (R -> ((s s s)))
     (H -> ((a b)))
     (K -> ((d h)))
     (B -> ((e c d h)))
     )
   '(S A B H R K)))

(define G5
  (build-grammar
   '((S -> ((A) (B) (C)))
     (A -> ((c A1 b)))
     (A1 -> ((d h)))
     (B -> ((c B1)))
     (B1 -> ((d s)))
     (C -> ((d C1 s)))
     (C1 -> ((h b r)))
     )
   '(S A B C A1 B1 C1)))

(define H 1)

(define max (maxg G5 'S 100))
(define grammchains (grammatical-chains G5 'S H 12))
(displayln "G5's chains:")
(show-chains grammchains)
(define mgrammchains (grammatical-chains max 'S H 12))
(displayln "Maxgrammar's chains:")
(show-chains mgrammchains)



(displayln "Computing G5's simple chains:")
(define simple-chains (chains-as-set (chains G5 'S H 100)))

(displayln "Computing Maxgrammar's simple chains:")
(define msimple-chains (chains-as-set (chains max 'S H 100)))


 

(displayln "G5's conflicts:")
(parallel-find+show-conflicts grammchains simple-chains)


(displayln "Maxgrammar's conflicts:")
(parallel-find+show-conflicts mgrammchains msimple-chains)



