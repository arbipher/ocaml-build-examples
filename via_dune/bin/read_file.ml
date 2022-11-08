(* open Z3 *)

let ctx = Z3.mk_context [] ;;

module Sudu_z3 = Sudu.Z3_api.Make(struct let ctx = ctx end)

let () = 
  let smt_file = Sys.argv.(1) in
  let ast_v = Z3.SMT.parse_smtlib2_file ctx smt_file [] [] [] [] in
  let exps = Z3.AST.ASTVector.to_expr_list ast_v in
  print_endline @@ Z3.Expr.to_string (List.hd exps)