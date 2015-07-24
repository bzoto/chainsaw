#lang racket
(require "./chains.ss")
  
(define G2
  (build-grammar 
   '((S -> ((X) (Y)))
     (X -> ((r a a a a X d d d d s) (h a a a a A d d d d s)))
     (A -> ((a A c) (a c)))
     (Y -> ((r a a a a Y d d d d s) (h a a a a C d d d d s)))
     (C -> ((c C d) (c d)))
     )
   '(S X A C Y H D)))


(define grammchains (grammatical-chains G2 'S 4 30))
(show-chains grammchains)


(show-conflicts
          (find-conflicts grammchains
                          (chains-as-set (chains G2 'S 4 100))
                          ))


;; ###[[haaaadddds]]###
;; ###[[haaaa[c[c[cd]d]d]dddds]]###
;; ###[[raaaadddds]]###
;; ###[[raaaa[haaaadddds]dddds]]###
;; ###[[haaaa[a[ac]c]dddds]]###
;; ###[]###
;; ###[[haaaa[cd]dddds]]###
;; ###[[raaaa[raaaadddds]dddds]]###
;; ###[[haaaa[ac]dddds]]###
;; ###[[haaaa[c[cd]d]dddds]]###
;; ###[[haaaa[a[a[ac]c]c]dddds]]###
;; 
;; Example strings:
;; ###haaaaacdddds###
;; ###haaaacddddds###
;; ###raaaahaaaaacddddsdddds###
;; ###haaaaaaccdddds###
;; ###raaaahaaaacdddddsdddds###
;; ###haaaaccdddddds###
;; ###raaaaraaaahaaaaacddddsddddsdddds###
;; ###raaaahaaaaaaccddddsdddds###
;; ###haaaaaaacccdddds###
;; ###raaaaraaaahaaaacdddddsddddsdddds###
;; ###raaaahaaaaccddddddsdddds###
;; ###haaaacccddddddds###
;; ###raaaaraaaaraaaahaaaaacddddsddddsddddsdddds###
;; ###raaaaraaaahaaaaaaccddddsddddsdddds###
;; ###raaaahaaaaaaacccddddsdddds###
;; ###haaaaaaaaccccdddds###
;; ###raaaaraaaaraaaahaaaacdddddsddddsddddsdddds###
;; ###raaaaraaaahaaaaccddddddsddddsdddds###
;; ###raaaahaaaacccdddddddsdddds###
;; ###haaaaccccdddddddds###
;; 
;; Simple chains:
;; aaa[ac]ccd
;; ccc[cd]ddd
;; aac[cd]ddd
;; aaa[haaaadddds | ac | cd | raaaadddds]ddd
;; acc[cd]ddd
;; ###[haaaadddds | raaaadddds]###
;; aaa[ac]ccc
;; aaa[ac]cdd
;; Conflicts:
;; acc[cd]ddd VS ###[[haaaa[a[a[ac]c]c]dddds]]###
;; aaa[ac]cdd VS ###[[haaaa[c[cd]d]dddds]]###
;; aaa[cd]ddd VS ###[[haaaa[ac]dddds]]###
;; aaa[ac]ddd VS ###[[haaaa[cd]dddds]]###
;; aac[cd]ddd VS ###[[haaaa[a[ac]c]dddds]]###
;; aaa[ac]ccd VS ###[[haaaa[c[c[cd]d]d]dddds]]###

;; ####[[raaaa[haaaadddds]dddds]]####
;; ####[[haaaa[a[ac]c]dddds]]####
;; ####[[haaaa[cd]dddds]]####
;; ####[[haaaa[c[cd]d]dddds]]####
;; ####[[haaaa[ac]dddds]]####
;; ####[[haaaadddds]]####
;; ####[[raaaadddds]]####
;; ####[[haaaa[c[c[cd]d]d]dddds]]####
;; ####[]####
;; ####[[haaaa[a[a[ac]c]c]dddds]]####
;; ####[[raaaa[raaaadddds]dddds]]####
;;
;; Simple chains:
;; aaaa[ac]cccd
;; cccc[cd]dddd
;; aaaa[ac]ccdd
;; aaaa[ac]cccc
;; aaaa[haaaadddds | ac | cd | raaaadddds]dddd
;; aaac[cd]dddd
;; ####[haaaadddds | raaaadddds]####
;; aaaa[ac]cddd
;; accc[cd]dddd
;; aacc[cd]dddd

