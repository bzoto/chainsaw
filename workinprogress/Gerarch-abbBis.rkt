#lang racket
(require "./chains.ss")
  
(define G1
  (build-grammar 
   '((S -> ((X) (Y))(a b b) ( a b b c))
     (X -> ((a a X b b b b) ( a a b b b b)))
     (Y -> ((a a Y b b b b c) ( a a b b b b c))))
   '(S X Y)))


(define grammchains (grammatical-chains G1 'S 1 20))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G1 'S 1 100))
                          ))

;; #[[aa[aabbbb]bbbb]]#
;; #[[aabbbbc]]#
;; #[[aa[aabbbbc]bbbbc]]#
;; #[[aabbbb]]#
;; #[[aa[aa[aabbbb]bbbb]bbbb]]#
;; #[]#
;; Example strings:
;; #aabbbb#
;; #aabbbbc#
;; #aaaabbbbbbbb#
;; #aaaabbbbcbbbbc#
;; #aaaaaabbbbbbbbbbbb#
;; #aaaaaabbbbcbbbbcbbbbc#
;; #aaaaaaaabbbbbbbbbbbbbbbb#
;; #aaaaaaaabbbbcbbbbcbbbbcbbbbc#
;; #aaaaaaaaaabbbbbbbbbbbbbbbbbbbb#
;; #aaaaaaaaaabbbbcbbbbcbbbbcbbbbcbbbbc#
;; #aaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbb#
;; #aaaaaaaaaaaabbbbcbbbbcbbbbcbbbbcbbbbcbbbbc#
;; #aaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbb#
;; #aaaaaaaaaaaaaabbbbcbbbbcbbbbcbbbbcbbbbcbbbbcbbbbc#
;; #aaaaaaaaaaaaaaaabbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb#
;; #aaaaaaaaaaaaaaaabbbbcbbbbcbbbbcbbbbcbbbbcbbbbcbbbbcbbbbc#
;;  
