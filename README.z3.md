title: Z3 and its internal
---


# Prerequisite

This check things work well.


```sh
$ z3/build/z3 --version
Z3 version 4.12.0 - 64 bit
```

and 

```sh
$ ls smt_files | wc -l
6
```

# Motivation

This seminar/writeup is for demystifying Z3. At some moment, we realized we may not continue to treat Z3 as a magical blackbox any more.

References:

- https://microsoft.github.io/z3guide/
- https://theory.stanford.edu/~nikolaj/programmingz3.html

Project `z3` contains :

- an executable `z3.exe` plus
- a library `z3` with bindings in many languages.
  
`z3` is mainly written in C++. Its OCaml binding is built around a C wrapper upon its C++ library.

# Terms

Basics:

- `SAT`: boolean SATisfiability
- `SMT`: Satisfiability Modulo Theories

Theories:

![smt logics](http://smtlib.cs.uiowa.edu/Logics/logics.png)

- `formula`(`expression`, `constraint`): s-expression in SMT-LIB.
- `logic`: e.g. `QF` for quantifier free; `AX` for theory `ArraysEX`, `BV` for `FixedSizeBitVectors`; `IA`/`RA` for `Integer/Real Arithmetic`; `L`/`N` (before `IA`/`RA`) for linear/non-linear fragment; `UF` for free sort and function symbols.
- `theory`: concerning equivalent expressions with meta-variables.
- `quantifier`: for any `x` such that ..; there exists a `x` such that ..

Here is a simple example:

<!-- $MDX file=smt_files/simple.smt2 -->
```
(declare-const a Int)
(declare-fun f (Int Bool) Int)
(assert (< a 10))
(assert (> (f a true) 100))
(check-sat)
(get-model)
```

with the running result:

```sh
$ z3/build/z3 smt_files/simple.smt2
sat
(
  (define-fun a () Int
    0)
  (define-fun f ((x!0 Int) (x!1 Bool)) Int
    101)
)
```

Concepts:

- `solver`
- `uninterpreted functions`
- `sort` / `type` / `kind`
- `model`
- `proof`
- `unsat_core`

To see config, param, and statictics:

<!-- $MDX file=smt_files/api_get_info.smt2 -->
```
(declare-fun dummy () Bool)
(assert (not dummy))
(check-sat)
(get-model)
(get-info :error-behavior)
(get-info :name)
(get-info :authors)
(get-info :version)
(get-info :status)
(get-info :reason-unknown)
(get-info :all-statistics)
(get-info :assertion-stack-levels)
(get-info :rlimit)
```

```sh
$ z3/build/z3 smt_files/api_get_info.smt2
sat
(
  (define-fun dummy () Bool
    false)
)
(:error-behavior continued-execution)
(:name "Z3")
(:authors "Leonardo de Moura, Nikolaj Bjorner and Christoph Wintersteiger")
(:version "4.12.0")
(:status unknown)
(:reason-unknown "")
(:max-memory    19.09
 :memory        18.71
 :num-allocs    644868
 :rlimit-count  21
 :sat-decisions 1
 :sat-mk-var    3
 :sat-units     1
 :time          0.03)
(:assertion-stack-levels 0)
(:rlimit 21)
```

`rlimit` is an internal resource counter. 

See the [post](https://stackoverflow.com/questions/45457131/what-is-the-relation-between-options-rlimit-and-timeout) on stackoverflow from the developer

> Q1: What kind of "solver resources" does rlimit restrict - just time or also memory?
> A1: Whatever we think makes sense. The idea is to count something like "basic operations", but that definition changes as we go ahead and add new "operations". There is no guarantee that it will stay the same for different versions of Z3. However, as long as you keep using the same binary, it is deterministic.

(not useful here, [z3/rlimit.h](https://github.com/Z3Prover/z3/blob/21e59f7c6e/src/util/rlimit.h), [issue: resource limit in addition to time limit](https://github.com/Z3Prover/z3/issues/56))

Solving:

- `strategy`
- `goal`
- `tactic`
- `probe`
- `objective`
- `optimization`

Extensions:

- `soft constraint`

Implementation:

- `parameter`: https://github.com/Z3Prover/z3/blob/master/Parameters.md
- `statistics`: `(get-stat)`



