open Z3

let ctx = Z3.mk_context []
let solver = Solver.mk_solver_s ctx "HORN"

(* (declare-fun Inv (Int) Bool)
   (assert (Inv 0))
   (assert (forall ((x Int)) (=> (and (< x 5) (Inv x)) (Inv (+ x 1))))) *)

let _ =
  set_global_param "fp.engine" "spacer";
  set_global_param "fp.spacer.gpdr" "true";
  set_global_param "fp.xform.inline_eager" "false";
  set_global_param "fp.xform.inline_linear" "false";
  let box_int i = Arithmetic.Integer.mk_numeral_i ctx i in
  let int_sort = Arithmetic.Integer.mk_sort ctx in
  let bool_sort = Boolean.mk_sort ctx in
  let inv = FuncDecl.mk_func_decl_s ctx "Inv" [ int_sort ] bool_sort in
  let a1 = Expr.mk_app ctx inv [ box_int 0 ] in
  let a2 =
    let x_const = Expr.mk_fresh_const ctx "x" int_sort in
    Quantifier.expr_of_quantifier
      (Quantifier.mk_forall_const ctx [ x_const ]
         (Boolean.mk_implies ctx
            (Boolean.mk_and ctx
               [
                 Arithmetic.mk_lt ctx x_const (box_int 5);
                 (* Expr.mk_app ctx inv [ x_const ]; *)
               ])
            (Expr.mk_app ctx inv
               [ Arithmetic.mk_add ctx [ x_const; box_int 1 ] ]))
         None [] [] None None)
  in
  Solver.add solver [ a1; a2 ];
  (* Solver.add solver (Convert.test5 ctx); *)
  match Solver.check solver [] with
  | SATISFIABLE ->
      Format.printf "sat\n\n";
      let model = solver |> Solver.get_model |> Option.get in
      model |> Model.to_string |> Format.printf "Model:\n%s\n\n";
      solver |> Solver.to_string |> Format.printf "Solver:\n%s";
      let eval_for n =
        let e =
          Model.eval model (Expr.mk_app ctx inv [ box_int n ]) true
          |> Option.get
        in
        e |> Expr.to_string |> Format.printf "P%d: %s\n" n
      in
      eval_for 0;
      eval_for 4;
      eval_for 10
  | UNSATISFIABLE -> Format.printf "unsat\n"
  | UNKNOWN ->
      Format.printf "unknown\n\n";
      solver |> Solver.to_string |> Format.printf "Solver:\n%s"
