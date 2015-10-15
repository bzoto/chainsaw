#lang racket
(require "./chains.ss")

(define G1
  (build-grammar 
   '((E -> ((E + T) ( T * F ) (< E >) (a)))
     (T -> ((T * F) (a) (< E >)))
     (F -> ((a) (< E >)))
     )
   '( S E T F)))

(define G2
  (build-grammar 
   '((E -> ((E + T) ( T * F ) (A * F) (a)))
     (T -> ((T * F) (A * F) (a)))
     (A -> ((< E + T >)))
     (F -> ((a) (< E + T >)))
     )
   '(E T F A)))


(define G3
  (build-grammar 
   '((S -> ((<|A|>) (*|A|#)))
     (<|A|> -> ((a)))
     (*|A|# -> ((a)))
     )
   '( S <|A|> *|A|# *|<>|# )))

(define H 1)

(define max (maxg G2 'E 100))
(define grammchains (grammatical-chains G2 'E H 12))
(show-chains grammchains)
(displayln " -XXXXXXXXXX-")
(define mgrammchains (grammatical-chains max 'E H 12))
(show-chains mgrammchains)

(define simple-chains (chains-as-set (chains G2 'E H 100)))
(define msimple-chains (chains-as-set (chains max 'E H 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)

(parallel-find+show-conflicts mgrammchains msimple-chains)


;(sufficient-conditions simple-chains)




;(define max (maxg G1 'E 100))
;(define grammchains (grammatical-chains G1 'E H 15 5 ))
;(show-chains grammchains)
;(displayln "-------")
;(define grammchains-max (grammatical-chains max 'E H 15 5 ))
;(show-chains grammchains-max)

;(show-conflicts
          ;(find-conflicts grammchains
                         ;(chains-as-set (chains G1 'E H 100))
                        ; ))
