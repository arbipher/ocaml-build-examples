(* open Z3 *)

let ctx = Z3.mk_context []

module Sudu_z3 = Sudu.Z3_api.Make (struct
  let ctx = ctx
end)

open Sudu

let () =
  Z3.toggle_warning_messages true;
  ignore @@ Z3.Log.open_ "this.log";
  Z3.enable_trace "asserted_formulas";

  let smt_file = Sys.argv.(1) in
  let phis = Bugcase.get_phis ctx smt_file in
  let solver = Z3.Solver.mk_solver ctx None in
  let result = Bugcase.get_result phis solver in
  Bugcase.print_result solver result
