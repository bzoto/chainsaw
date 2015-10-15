# Chainsaw
Various utilities for Locally Chain-Parsable Languages
(c) 2015 by Matteo Pradella

Caveat emptor! This is a prototype and contains untested, undocumented, and roughly sketched algorithms.

# Introduction

This program contains a number of utilities for defining and analyzing Locally Chain-Parsable Languages (LCPLs). Their definition and theory originally appeared in:

*Stefano Crespi-Reghizzi, Violetta Lonati, Dino Mandrioli, Matteo Pradella: Locally Chain-Parsable Languages. MFCS 2015: 154-166*

We refer to that and the subsequent publications on the subject for all the used concepts definitions.

# Basic interface and usage

The program is written in Racket (http://racket-lang.org/), and the main part is in the *chain.ss* file. For this reason, every script using Chainsaw, should begin with
    #lang racket
    (require "./chains.ss")

To define a grammar, the user should use the *build-grammar* procedure, that accepts as input the list of grammar rules, each a list by itself, and the list of nonterminal symbols.
For example, the rule *A -> a B a | b* is written as the list *(A -> (a B a) (b))*.
To illustrate, let's define a grammar and call it *G1*:

    (define G1 (build-grammar
                           '((E -> ((E + T) (T * F) (e)))
                             (T -> ((T * F) (e)))
                             (F -> ((e))))
                           '(E T F)))
    

# Check if a Grammar is LCP

To check if a grammar is actually LCP, or to check e.g. if the grammatical chains of a grammar conflict with the xchains of another grammar, we need to compute (or provide) a set of chains and a set of xchains.


## Chains

To compute the set of chains of a given grammar, there is a command called *compute-chains* which takes as input:

  - a grammar *G*,
  - the grammar's axiom, and
  - a numerical bound *k*.

*G*'s chains are computed by generating all the sentential forms up to *k* applications of the grammar's productions.

For instance, considering *G1*:

    (define Sc (compute-chains G1 'E 100)))

During the computation, all the found chains are also displayed, together with
the example strings of the language derived by the algorithm:

    Example strings:
    #e#
    #e+e#
    #e+e#
    #e*e#
    #e*e#
    #e+e*e#
    #e+e*e#
    #e+e*e#
    #e+e*e#
    #e+e*e#
    #e+e*e#
    #e+e+e#
    #e+e+e#
    #e*e+e#
    #e*e+e#
    #e+e+e#
    #e+e+e#
    Simple chains:
    *[e]#
    #[* | e]*
    +[* | e]*
    *[e]+
    +[* | e]+
    *[e]*
    #[+ | * | e]+
    +[* | e]#
    #[+ | * | e]#


## Xchains

Analogously, to compute the set of xchains of a given grammar, there is a command called *compute-xchains* which takes as input:

  - a grammar *G*,
  - the grammar's axiom,
  - a numerical value *L*, and
  - an *optional* bound *k*.

*G*'s xchains are computed by generating all the sentential forms, and discarding all the nonterminals, and keeping only the sentential forms that have length at most *L*, or between *L-k* and *L*, if the last parameter is set. 

    (define Xc (compute-xchains G1 'E 14 4))

In this case *Xc* contains the set of computed xchains. If we want to
show them on the screen, we perform:

    (show-chains Xc)

obtaining, among the others, the following xchains:

    #[[[[*]*]*]*]#
    #[[[[*]*]*]+]#
    #[[[[+]+]+]+]#
    #[[*[e]]+[e]]#
    #[[[+]+]+[*]]#
    #[[[*[e]]+]+]#
    #[[*]*[e]]#
    #[[[e]*]*]#
    #[[[e]*]+]#


## Conflicts

After computing, or defining, a set of chains (*Sc* in our example) and a set of xchains (*Xc*), we can test if they are *conflictual* or not.
The basic command to perform this operation is *find-conflicts*, which accepts
as its first argument a set of xchains, as second argument a set of chains,
then returns the lists of their conflicts.
To display such list on screen, a command called *show-conflicts* is provided.

For instance

    (show-conflicts (find-conflicts Xc Sc))

will display just "Conflicts:", because *G1* is actually LCP.

On the other hand, if we modify *G1* to make it not LCP by changing its first
production like this:
        
    (E -> ((E + T) (T)))

We obtain several conflicts:

    Conflicts:
    #[+]+ VS #[[[]+]+[e]]#
    #[+]+ VS #[[[[]+]+]+]#
    #[+]+ VS #[[[]+]+[*]]#
    #[+]+ VS #[[[]+]+]#


## A parallel variant

If we are using a multi-core or multi-processor machine, there is a parallel
variant of the same algorithm available, called *parallel-find+show-conflics*.
The only difference is that it does not return a list of conflicts, but just
displays them on the screen.

    (parallel-find+show-conflicts Xc Sc)


