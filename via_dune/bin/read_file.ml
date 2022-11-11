(* open Z3 *)

(* See https://github.com/Z3Prover/z3/blob/master/src/params/context_params.h *)
let ctx =
  Z3.mk_context
    [
      ("auto_config", "true");
      ("debug_ref_count", "false");
      ("dot_proof_file", "proof2.dot");
      ("dump_models", "true");
      ("encoding", "ascii");
      (* ("memory_high_watermark", "33334444"); *)
      (* ("memory_high_watermark_mb", "33334444"); *)
      (* ("memory_max_alloc_count", "44445555"); *)
      (* ("memory_max_size", "44445555"); *)
      ("model", "true");
      ("model_validate", "true");
      ("rlimit", "0");
      ("smtlib2_compliant", "false");
      ("stats", "true");
      ("timeout", "3000");
      ("trace", "true");
      ("trace_file_name", "z4.log");
      ("type_check", "true");
      ("unsat_core", "true");
      ("well_sorted_check", "true");
    ]

module Sudu_z3 = Sudu.Z3_api.Make (struct
  let ctx = ctx
end)

open Sudu

let () =
  Z3.toggle_warning_messages true;
  ignore @@ Z3.Log.open_ "this.log";
  Z3.enable_trace "asserted_formulas";

  (* See
     https://github.com/Z3Prover/z3/tree/master/src/params
     https://github.com/Z3Prover/z3/blob/master/scripts/pyg2hpp.py
     https://github.com/Z3Prover/z3/blob/master/src/api/api_params.cpp

     https://github.com/Z3Prover/z3/blob/master/src/ast/pp_params.pyg
     .pyg is used to generate C++ header file .hpp
  *)

  (* Q: is there a place to lookup all parameters?
     A: https://github.com/Z3Prover/z3/blob/master/Parameters.md *)
  Z3.set_global_param "debug_ref_count" "true";
  Z3.set_global_param "memory_high_watermark" "44445555";
  Z3.set_global_param "memory_high_watermark_mb" "44445555";
  Z3.set_global_param "memory_max_alloc_count" "44445555";
  Z3.set_global_param "memory_max_size" "44445555";
  Z3.set_global_param "verbose" "2";
  Z3.set_global_param "warning" "true";
  Z3.set_global_param "pp.decimal" "true";
  Z3.set_global_param "solver.lemmas2console" "true";

  let smt_file = Sys.argv.(1) in
  let phis = Bugcase.get_phis ctx smt_file in
  let solver = Z3.Solver.mk_solver ctx None in
  let result = Bugcase.get_result phis solver in
  Bugcase.print_result solver result
