;; ----------------------------
;; A dumb chain computer
;; (c) by Matteo Pradella, MMXV
;; ----------------------------

#lang racket

(provide
 chains
 build-grammar
 grammatical-chains
 chains-as-set
 show-chains
 find-conflicts
 show-conflicts
 parallel-find+show-conflicts
 right-chain-parts
 left-chain-parts
 sufficient-conditions
 maxg
 )

;; --- interface ---

(define (build-grammar gr nt)
  "gr is a list of rules like (S -> ((a S b) (c))), nt are the nonterminals"
  (let ((G (make-hash)))
    (for-each (lambda (r)
                (hash-set! G
                           (nonterm (car r)) ; the nonterminal
                           (map (lambda (t)
                                  (map (lambda (u)
                                         (if (member u nt)
                                             (nonterm u)
                                             u))
                                       t))
                                (caddr r))
                           ))
              gr)
    G))


;; --- the code ---

(struct nonterm (symb) ;; data structure for nonterminals
  #:transparent)       ;; for equality


(define (terminal-sf? sf)
  (andmap (lambda (s)
            (not (nonterm? s))) sf))

(define (before-k lst i k)
  (for/list ([x (in-range (- i k) i)])
    (list-ref lst x)))

(define (after-k lst i k)
  (for/list ([x (in-range (+ i 1) (+ i k 1))])
    (list-ref lst x)))

(define (sf-contexts sf k)
  "returns nonterminal + context, if all terminal"
  (let loop ((x (car sf))
             (L (cdr sf))
             (i 0)
             (res '())
             )
    (when (nonterm? x)
      (let ((left  (before-k sf i k))
            (right (after-k sf i k)))
        (when (and
               (terminal-sf? left)
               (terminal-sf? right))
          (set! res
                (cons (list left x right)
                      res)))))
    (if (null? L)
        res
        (loop (car L)
              (cdr L)
              (+ i 1)
              res))))

(define (apply-rules sf G)
  (let loop ((out  '())
             (left '())
             (right sf))
    (if (null? right)
        out
        (let ((x   (car right))
              (xs  (cdr right)))
          (loop (if (nonterm? x)
                    (append (map (lambda (f) (append left f xs))
                                 (hash-ref G x))
                            out)
                    out)
                (append left (list x))
                xs)))))

(define (border k)
  (for/list ((x (in-range k))) '|#|))


(define (get-contexts G axiom k steps)
  (let ((ctxs (make-hash))
        (bord (border k)))
    (hash-set! ctxs (nonterm axiom) (mutable-set (list bord bord)))
    (let loop ((sfs  (list (append bord (list (nonterm axiom)) bord)))
               (cnt  0))
      (if (or (null? sfs)(= steps cnt))
          ctxs
          (let ((x  (filter (lambda (t)
                              (define r (terminal-sf? t))
                              (when r
                                (show-list-as-string t)
                                (newline))
                              (not r))
                            (apply-rules (car sfs) G)))
                (xs (cdr sfs)))
            (for-each (lambda (c)
                        (let* ((left (car c))
                               (nt (cadr c))
                               (right (caddr c))
                               (re (hash-ref ctxs nt (mutable-set))))
                          (set-add! re (list left right))
                          (hash-set! ctxs nt re)))
                      (apply append (map (lambda (s) (sf-contexts s k))
                                         x)))
            (loop (append xs x) (+ 1 cnt)))))))


(define (drop-nt lst)
  (filter (lambda (x) (not (nonterm? x))) lst))

(define (show-list-as-string lst)
  (for-each (lambda (t) (display t)) lst))

(define (show-alternatives lst-of-lst)
  (unless (null? lst-of-lst)
    (for-each (lambda (l)
                (show-list-as-string l)
                (display " | "))
              (cdr lst-of-lst))
    (show-list-as-string (car lst-of-lst))))


(define (chains G axiom k steps) ;; these are the simple chains
  (displayln "Example strings:")
  (let* ((contexts (get-contexts G axiom k steps))
         (nts      (hash-keys contexts))
         (bodys    (make-hash))
         (the-chains (make-hash)))

    (for-each (lambda (n)
                (let ((bd (filter (lambda (x)
                                    (not (null? x)))
                                  (map drop-nt (hash-ref G n)))))
                  (hash-set! bodys n (list->set bd))))
              nts)

    (for-each (lambda (n)
                (set-for-each (hash-ref contexts n)
                              (lambda (c)
                                (let ((old (hash-ref the-chains c (set))))
                                  (hash-set! the-chains
                                             c
                                             (set-union old (hash-ref bodys n)))))
                              )
                )
              nts)
    (displayln "Simple chains:")
    (hash-for-each the-chains
                   (lambda (k v)
                     (show-list-as-string (car k))
                     (display "[")
                     (show-alternatives (set->list v))
                     (display "]")
                     (show-list-as-string (cadr k))
                     (newline)))

    the-chains
    ))


(define (chains-as-set chains-hash)
  (let ((out (mutable-set)))
    (hash-for-each chains-hash
                   (lambda (k v)
                     (set-for-each v
                                   (lambda (body)
                                     (set-add! out
                                               (append
                                                (list (car k))
                                                (list body)
                                                (list (cadr k))))))))
    out))


(define (iterated-p-car list-of-lists)
  "iterated cartesian product"
  (define (foldl1 fun lst)
    (foldl fun (car lst) (cdr lst)))

  (foldl1 (lambda (X Y)
	    (for*/list ((x X)
			(y Y))
	      (cond
	       ((and (list? x)(list? y))
		(append y x))
	       ((list? y) 
		(append y (list x)))
	       ((list? x)
		(append (list y) x))
	       (else
		(append (list y)(list x))))))
	  list-of-lists))


(define (max-ntcontext max-nt)
  (list (car max-nt) (last max-nt)))

(define (max-ntbody max-nt)
  (for/list ((n (cdr max-nt))
             (i (range 2 (length max-nt))))
    n))

(define (compatible-max-nt context max-nt)
  (let* ((ffun (cond
                ((equal? context (list '--everything-- '--everything--))
                 (lambda (x) #t))
                ((equal? (car context) '--everything--)
                 (lambda (x) (equal? (last x)(cadr context))))
                ((equal? (cadr context) '--everything--)
                 (lambda (x) (equal? (car x)(car context))))
                (else (lambda (x) (equal? (max-ntcontext x) context)))
                ))
         (compat (filter ffun
                         (set->list max-nt))))
    (map (lambda (x) (list (nonterm x))) compat)))

(define (rpart->stencils rpart nt-max)
  (let loop ((cur  (car rpart))
             (rest (append (cdr rpart) (list '--everything--)))
             (new  '())
             (prev '--everything--))
    (if (pair? rest)
        (loop (car rest)
              (cdr rest)
              (append new
                      (if (nonterm? cur)
                          (list (compatible-max-nt (list prev (car rest)) nt-max))
                          (list (list cur))))
              cur)
        new)))


(define (maxg G axiom steps)
  (displayln "Example strings:")
  (let* ((contexts (get-contexts G axiom 1 steps))
         (nts      (hash-keys contexts))
         (ctxs     (mutable-set))
         (bdxs     (mutable-set))
         (bodys    (make-hash))
         (rparts   (mutable-set))
         (rparts1  (mutable-set))
         (nt-max   (mutable-set))
         (rul-max  (make-hash))
         )

    (for-each (lambda (n) ; compute all the bodys
                (let ((bd (filter (lambda (x)
                                    (not (null? x)))
                                  (map drop-nt (hash-ref G n)))))
                  (hash-set! bodys n (list->set bd))))
              nts)

    ;; (for-each (lambda (n) ; nonterminals and rparts (stricter version)
    ;;             (let ((cc  (hash-ref contexts n))
    ;;                   (bds (hash-ref bodys n)))

    ;;               (for-each (lambda (p)
    ;;                           (set-add! rparts p))
    ;;                         (hash-ref G n))

    ;;               (for* ((c cc)
    ;;                      (b bds))
    ;;                 (set-add! nt-max (append (car c) b (cadr c))))))
    ;;           nts)

    ;; nonterminals and rparts
    (for-each (lambda (n) 
                (let ((cc  (hash-ref contexts n))
                      (bds (hash-ref bodys n)))

                  (set-union! bdxs bds)
                  (set-union! ctxs cc)

                  (for-each (lambda (p)
                              (set-add! rparts p))
                            (hash-ref G n))

                  ))
              nts)
    (for* ((c ctxs) ;; nonterminals (looser version)
           (b bdxs))
      (set-add! nt-max (append (car c) b (cadr c))))

    (set-for-each rparts (lambda (r)
                           (set-union! rparts1
                                       (list->set (iterated-p-car
                                                   (rpart->stencils r nt-max))))))

    (for* ((p rparts1)
           (n nt-max)
           #:when (equal? (max-ntbody n)
                          (filter (lambda (x) (not (nonterm? x))) p)
                          ))
      (let ((old (hash-ref rul-max (nonterm n) (set))))
        (hash-set! rul-max (nonterm n) (set-union old (set p)))
        ))

    (hash-for-each rul-max (lambda (n p)
                             (hash-set! rul-max n (set->list p))))

    (hash-set! rul-max (nonterm axiom)
               (list
                (for/list ((n nt-max)
                           #:when (equal? (max-ntcontext n) (list '|#| '|#|)))
                  (nonterm n))))

    (displayln "Max-grammar:")
    (hash-for-each rul-max
                   (lambda (l r)
                     (display l) (display " -> ")
                     (displayln r)(newline)))
    (displayln "--o-o--")

    rul-max
    ))






(define (grammatical-chains G axiom k maxlen . bound)
  "returns the grammatical chains, starting from the axiom.
   maxlen is the maximum length of the considered sentential forms.
   bound, if present, is used for a lower bound on the set of sentential forms
   returned." 
  (let ((bord (border k)))
    (let loop ((sfs  '())
               (left '())
               (right (append bord (list (nonterm axiom)) bord))
               (out (set)))
      (if (and (null? sfs)
               (null? right))
          out
          (if (null? right)
              (loop (cdr sfs)
                    '()
                    (car sfs)
                    out)
              (match-let*
               (((cons x xs) right))

               (if (nonterm? x)
                   (let-values (((newstuff newchains)
                                 (newstuff+newchains left (hash-ref G x)
                                                     x xs maxlen bound)))
                     (loop (append sfs newstuff)
                           (append left (list x))
                           xs
                           (set-union out newchains)))
                   (loop sfs
                         (append left (list x))
                         xs
                         out))))))))

(define (newstuff+newchains left right-parts x xs maxlen bound)
  (let ((newchains (mutable-set)))
    (let loop ((ns right-parts)
               (newstuff '()))
      (if (null? ns)
          (values newstuff newchains)

          (let* ((newchain  (append left
                                   (list '|[|)
                                   (car ns)
                                   (list '|]|) xs))
                 (nc (drop-nt newchain))
                 (lnc (length nc)))
            ;; keep only the longest chains
            (when (or (null? bound)
                      (<= (- maxlen (car bound))
                          lnc
                          maxlen))
              (set-add! newchains nc))

            (loop (cdr ns)
                  (if (<= lnc maxlen)
                      (cons newchain newstuff)
                      newstuff)))))))

(define (show-chains the-set)
  (set-for-each the-set
                (lambda (s)
                  (displayln (apply string-append
                                    (map symbol->string s))))))





(define (3-factors lst)
  (let ((out '())
        (n (- (length lst) 1)))
    (let outer ((i 1))
      (when (< i n)
        (let inner ((j (+ 1 i)))
          (when (<= j n)
            (define-values (a b) (split-at lst i))
            (define-values (c d) (split-at b (- j i)))
            (set! out (cons (list a c d) out))
            (inner (+ j 1))))
        (outer (+ i 1))))
    out))


(define (drop-brackets lst)
  (filter (lambda (x)
            (not (member x '(|[| |]|))))
          lst))

(define (h+ lst k)
  (let ((l1 (drop-brackets lst)))
    (if (< (length l1) k)
        '()
        (take-right l1 k))))

(define (h- lst k)
  (let ((l1 (drop-brackets lst)))
    (if (< (length l1) k)
        '()
        (take l1 k))))

(define (is-bracketed? lst y)
  (let loop ((cur   lst)
             (the-y y)
             (state -1))
    (cond
      ((null? cur)
       (= state 2))
      ((and (eq? '|[| (car cur))
            (= -1 state))
       (loop (cdr cur) the-y 0))
      ((and (eq? '|[| (car cur))
            (= 0 state))
       (loop (cdr cur) the-y 0))
      ((and (null? the-y) 
            (eq? '|]| (car cur))
            (or (= 1 state)(= 2 state)))
       (loop (cdr cur) the-y 2))
      ((null? the-y) #f)
      ((and (eq? (car the-y)(car cur))
            (or (= 0 state)(= 1 state)))
       (loop (cdr cur) (cdr the-y) 1))
      (else #f))))


(define (conflictual c x y z h)
  "c is a chain, x[y]z is a simple chain"
  (let ((cc (3-factors c)))
    (filter 
     (lambda (fac)
       (match-let (((list X Y Z) fac))
         (and
          (equal? x (h+ X h))
          (equal? z (h- Z h))
          (equal? (drop-brackets Y) y)
          (not (is-bracketed? Y y))
          (not (member (last X) '(|[| |]|)))
          (not (member (car Z)  '(|[| |]|)))
          )))
     cc)))


(define (show-conflicts cf)
  (displayln "Conflicts:")
  (for-each (lambda (c)
              (match-let (((list (list l c r)
                                 ch)
                           c))
                (show-list-as-string l)
                (display "[")
                (show-list-as-string c)
                (display "]")
                (show-list-as-string r)
                (display " VS ")
                (displayln (apply string-append
                                  (map symbol->string ch)))
                ))
            cf))

(define (find-conflicts the-chains simple-chains)
  "returns the list of conflicts between the-chains and simple-chains"
  (let* ((a-chain (set-first simple-chains))
         (h (length (car a-chain)))
         (out '()))
    (set-for-each
     the-chains
     (lambda (c)
       (set-for-each
        simple-chains
        (lambda (s)
          (match-let* (((list x y z) s)
                       (confl (conflictual c x y z h)))
                      (when (pair? confl)
                        (set! out (cons (list s c)
                                        out))))))))
    out
    ))


(define (set-partition the-set n)
  "partitions a set in n subsets"
  (let ((m (floor (/ (set-count the-set) n)))
        (v (make-vector n #f)))
    (for ((i (in-range 0 n)))
      (vector-set! v i (mutable-set)))
    (let ((part 0)
          (curr 0))
      (set-for-each the-set
                    (lambda (s)
                      (set-add! (vector-ref v part) s)
                      (set! curr (+ 1 curr))
                      (when (and
                             (>= curr m)
                             (< part (- n 1)))
                        (set! curr 0)
                        (set! part (+ 1 part))))))
    v))

(define (parallel-find+show-conflicts the-chains simple-chains . proc)
  (let* ((a-chain (set-first simple-chains))
         (h (length (car a-chain)))
         (num-proc 
          (if (null? proc)
              (processor-count)
              (car proc))))
    (let ((schains (set-partition the-chains num-proc))
          (places  (for/vector ((x (in-range 0 num-proc)))
                     (place chan
                            (define pars (place-channel-get chan))
                            (match-let (((list the-chains s h) pars))
                              (place-channel-put chan
                                                 (find-conflicts
                                                  (list->set the-chains)
                                                  (list->set s))))))))
      (for ((x (in-range 0 num-proc)))
        (place-channel-put (vector-ref places x)
                           (list
                            (set->list (vector-ref schains x))
                            (set->list simple-chains)
                            h)))

      (for ((x (in-range 0 num-proc)))
        (show-conflicts
         (place-channel-get (vector-ref places x)))))))


;; --- Danger! Sufficient conditions area ---

(define (2-factors lst)
  (let ((out '())
        (n (length lst)))
    (let outer ((i 1))
      (when (< i n)
        (let-values (((a b) (split-at lst i)))
          (set! out (cons (list a b) out)))
        (outer (+ i 1)))
      out)))


(define (side-over? L1 L2 h)
  (and
   (>= (length L1) (+ h 1))
   (>= (length L2) (+ h 1))
   (or
    (equal?
     (take L1 (+ h 1))
     (take-right L2 (+ h 1)))
    (equal?
     (take L2 (+ h 1))
     (take-right L1 (+ h 1))))))


(define (chains->lists chains)
  (define out (mutable-set))
  (for ((c chains))
    (let ((it (append
               (car c)
               (cadr c)
               (caddr c))))
      (set-add! out it)))
  out)

(define (right-chain-parts chains)
  (define out (mutable-set))
  (for ((c chains))
    (let ((it (append
               (cadr c)
               (caddr c))))
      (if (set-member? out it)
          (begin
            (display "Multiple r-factors conflict: ")
            (displayln it))
          (set-add! out it))))
  out)

(define (left-chain-parts chains)
  (define out (mutable-set))
  (for ((c chains))
    (define it (append (car c)(cadr c)))
    (if (set-member? out it)
        (begin
          (display "Multiple l-factors conflict: ")
          (displayln it))
        (set-add! out it)))
  out)

(define (conditions-A+B r-chs h)
  (for* ((c1 r-chs)
         (c2 r-chs))
    (when
        (and 
         (not (equal? c1 c2))
         (side-over? c1 c2 h))
      (display "(A/B) conflict: ")
      (display c1)(display " VS ")
      (displayln c2))))


(define (condition-C chains)
  (define the-l (chains->lists chains))
  (displayln "C conflicts: ")
  (set-for-each
   (set-intersect
    (list->set
     (apply append
            (apply append
                   (append
                    (set-map the-l 3-factors)
                    (set-map the-l 2-factors)))))
    the-l)
   (lambda (s) (displayln s)))
  )

(define (sufficient-conditions simple-chains)
  (let* ((a-chain (set-first simple-chains))
         (h (length (car a-chain))))
    (displayln "Sufficient conditions conflicts:")
    (conditions-A+B (left-chain-parts simple-chains) h)
    (conditions-A+B (right-chain-parts simple-chains) h)
    (condition-C simple-chains)))
