open Sudu;;
open Bugcase;;
let ctx = Z3.mk_context [];;
let phis = Bugcase.get_phis ctx "weird_case/bad.smt2";;
let solver = Z3.Solver.mk_solver ctx None;;

let result = get_result phis solver;;