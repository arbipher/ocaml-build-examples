title: Z3 and its internal
---


# Prerequisite

This check things work well.

```sh
$ z3 --version
Z3 version 4.11.2 - 64 bit
```

and 

```sh
$ ls smt_files | wc -l
       4
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

- `SAT`
- `SMT`
- `logic`
- `formula`(`expression`, `constraint`)
- `solver`
- `theory`
- `quantifier`

Concepts:

- `uninterpreted functions`
- `sort` / `type` / `kind`
- `model`
- `proof`
- `unsat_core`

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



<!-- $MDX file=smt_files/dummy.smt2 -->
```smt2
(declare-fun dummy () Bool)
(assert (not dummy))
(check-sat)
(get-model)
```

```sh
$ z3/build/z3 smt_files/dummy.smt2
sat
(
  (define-fun dummy () Bool
    false)
)
```
