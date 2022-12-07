let get_phis ctx smt_file =
  let ast_v = Z3.SMT.parse_smtlib2_file ctx smt_file [] [] [] [] in
  let exps = Z3.AST.ASTVector.to_expr_list ast_v in
  exps

let get_result phis solver =
  Z3.Solver.add solver phis;
  let result = Z3.Solver.check solver [] in
  result

let print_result solver result =
  match result with
  | Z3.Solver.SATISFIABLE -> (
      match Z3.Solver.get_model solver with
      | Some model -> print_endline @@ Z3.Model.to_string model
      | None -> print_endline "No model")
  | _ -> print_endline @@ Z3.Solver.string_of_status result