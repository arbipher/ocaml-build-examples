open Core
open Z3

let ctx = Z3.mk_context []
let solver = Solver.mk_solver ctx None

let heavy () =
  let es =
    List.range 0 100000
    |> List.map ~f:(fun i ->
           SuduZ3.(
             eq
               (mk_string_s (string_of_int i))
               (mk_string_s (string_of_int (i + 1)))))
  in
  let _ = Z3.Solver.check solver es in
  true

let () =
  let x = Arithmetic.Integer.mk_const_s ctx "x" in
  let one = Arithmetic.Integer.mk_numeral_i ctx 1 in
  let eq_x_1 = Boolean.mk_eq ctx one x in
  Z3.Solver.add solver [ eq_x_1 ];
  ignore @@ Z3.Solver.check solver [];
  print_endline @@ Solver.to_string solver;
  ()
