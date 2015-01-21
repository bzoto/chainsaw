;; ----------------------------
;; A dumb chain computer
;; (c) by Matteo Pradella, MMXV
;; ----------------------------

#lang racket

(provide 
 chains 
 build-grammar
 grammatical-chains-conflicts
 chains-as-set
 show-chains
 )

(struct nonterm (symb) ;; data structure for nonterminals
        #:transparent) ;; for equality

(define (terminal-sf? sf)
  (andmap (lambda (s)
            (not (nonterm? s))) sf))

;; --- interface ---

(define (build-grammar gr nt)
  "gr is a list of rules like (S -> (a S b) (c)), nt are the nonterminals"
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
          (let ((x  (filter (lambda (t) (not (terminal-sf? t)))
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


(define (grammatical-chains-conflicts G axiom h maxlen simple-chains)
  (displayln "Conflict:")
  (call/ec
   (lambda (exit)
     (let ((bord (border h)))
       (let loop ((sfs  '())
                  (left '())
                  (right (append bord (list (nonterm axiom)) bord))
                  )
         (if (and (null? sfs)
                  (null? right))
             #f
             (if (null? right)
                 (loop (cdr sfs)
                       '()
                       (car sfs)
                       )
                 (match-let* 
                  (((cons x xs) right))

                  (if (nonterm? x)
                      (let ((newstuff
                             (newstuff+newchains left (hash-ref G x)
                                                 x xs h
                                                 maxlen simple-chains exit)))
                        (loop (append sfs newstuff)
                              (append left (list x))
                              xs
                              ))
                      (loop sfs
                            (append left (list x))
                            xs
                            ))))))))))

(define (newstuff+newchains left right-parts x xs h maxlen simple-chains exit)
  (let loop ((ns right-parts)
             (newstuff '()))
    (if (null? ns)
        newstuff
        (let* ((newchain  (append left
                                  (list '|[|)
                                  (car ns)
                                  (list '|]|) xs))
               (com (drop-nt newchain)))

          (for-each
           (lambda (cfl)
             (when (pair? (touch cfl))
               (show-conflicts (touch cfl))
               (exit #t)))
           (set-map
            simple-chains
            (lambda (s)
              (future (lambda ()
                        (match-let* (((list x y z) s))
                                    (if (pair? (conflictual com x y z h))
                                        (list (list s com))
                                        #f)))))))

          (loop (cdr ns)
                (if (<= (length newchain)
                        maxlen)
                    (cons newchain newstuff)
                    newstuff))))))
    

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
            (let-values (((a b) (split-at lst i)))
              (let-values (((c d) (split-at b (- j i))))
                (set! out (cons (list a c d) out))
                (inner (+ j 1))))))
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
             (state 0))
    (cond
      ((null? cur)
       (= state 2))
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