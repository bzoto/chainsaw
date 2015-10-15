#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
             '((E -> ((T * a - E)(T * - a - E)(a - E)(- a - E)
                      (T * a)(T * - a)(a)(- a)))
               (T -> ((T * a)(T * - a)(a)(- a))))
             '(E T)))
(define G3 (build-grammar
             '((E -> ((T * a E)(T * - a E)(a E)(- a E)
                      (- T * a)(- T * - a)(- a)(- - a)))
               (T -> ((T * a)(T * - a)(a)(- a))))
             '(E T)))
(define G2 (build-grammar
            '((S -> ((E) (T) (a) (- a)))
              (E -> ((T * a - E)(T * - a - E)
                     (a - a) ;; !
                     (- a - a)
                     ))
              (T -> ((T * a)(T * - a)
                     (a * a) ;; !
                     (a * - a)
                     )))
            '(E S T)))
(define G4 (build-grammar
             '((E -> ((T * a - E)(T * - a - E)(a - E)(- a - E)
                      (T * a)(T * - a)(a)(- a)))
               (T -> ((T * a)(T * - a)(a * a)(a * - a)(- a * - a)(- a * a))))
             '(E T)))

(define G5 (build-grammar
             '((E -> ((T a - E)(T - a - E)(a - E)(- a - E)
                      (T a)(T - a)(a)(- a)))
               (T -> ((T a *)(T - a *)(a *)(- a *))))
             '(E T)))


(define grammchains (grammatical-chains G5 'E 2 6))
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G5 'E 2 100)))


(time
 
;(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)



;(sufficient-conditions simple-chains)


