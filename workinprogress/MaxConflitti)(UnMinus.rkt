#lang racket
(require "./chains.ss")
  
(define GConfl>< (build-grammar
                       '((S -> ((if < E > < E >)(if < E > E)))
                         (E -> ((E + T) (a) (< E >)))
                         (T -> ((a) (< E >)))
                         )
                       '(S T E)))


(define GNoConfl><noUM (build-grammar
                       '((S -> ((if < E > < E >)(if < E > a + T)(if < E > a x T)(if < E > a + E)(if < E > a)))
                         (E -> ((T + E) (a) (< E >)))
                         (T -> ((a) (< E >) (a x T) (< E > x T) ))
                         )
                       '(S T E)))


(define GNoConfl><UM (build-grammar
             '((S -> ( (if A < E >) 
                       (if A a - - a )
                       (if A a - - a T )
                       (if A a - a )
                       (if A a )
                       (if < E > - a )
                       (if < E > - a T )
                       (if A < E > - - a )
                       (if A a - < E > )
                       (if A < E > - < E > )
                       (E) ))
               (A -> ((< E >)))
               (E -> ((E - - a T)
                      (E - a T)
                      (E - a) 
                      (E - - a) 
                      (a) 
                      (- a)
                      (- a T)
                      (a T)
                      (E - - < E > T)
                      (E - < E > T)
                      (E - < E >) 
                      (E - - < E >) 
                       
                      (- < E >)
                      (- < E > T)
                      ))
               
               (T -> (
                      (x - a T)
                      (x a T)
                      (x - a)
                      (x a)
                      (x - < E > T)
                      (x < E > T)
                      (x - < E >)
                      (x < E >)))
               )
             '(E T A S)))

(define H 1)

(define max (maxg GNoConfl><UM 'S 100))
(define grammchains (grammatical-chains GNoConfl><UM 'S H 14))
(show-chains grammchains)
(displayln " -XXXXXXXXXX-")
(define mgrammchains (time (grammatical-chains max 'S H 14)))
(show-chains mgrammchains)

(define simple-chains (chains-as-set (chains GNoConfl><UM 'S H 100)))
(define msimple-chains (chains-as-set (chains max 'S H 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)

(time
(parallel-find+show-conflicts mgrammchains msimple-chains)
)


;(define grammchains (grammatical-chains GNoConfl><UM 'S H 18 ))


;(show-chains grammchains)

;(define simple-chains (chains-as-set (chains GNoConfl><UM 'S H 100)))
                         
;(parallel-find+show-conflicts grammchains simple-chains)
