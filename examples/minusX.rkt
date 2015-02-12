#lang racket
(require "./chains.ss")
  
(define G1 (build-grammar
            '((E -> ((T * a - E)(T * - a - E)(a - E)(- a - E)
                     (T * a)(T * - a)(a)(- a)))
              (T -> ((T * a)(T * - a)(a)(- a))))
            '(E T)))

;; m=4, h=1, |V_N|=2,
;; bound = 4h+m+2|V_N|(2h+m)m = 4+4+4(2+4)4 = 104


(define grammchains (grammatical-chains G1 'E 1 24 7)) ;; limited
(show-chains grammchains)
(define simple-chains (chains-as-set (chains G1 'E 1 100)))


(time
 
(show-conflicts (find-conflicts grammchains simple-chains))

(parallel-find+show-conflicts grammchains simple-chains)

)



(sufficient-conditions simple-chains)


