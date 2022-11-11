# check()

From `solver.h`, search `check_sat`

```c++
// 
lbool L_FALSE | L_TRUE | L_UNDER 

// solver/solver.h
class solver: {
  lbool check_sat(unsigned num_assumptions, expr * const * assumptions);
  virtual lbool check_sat_core(unsigned num_assumptions, expr * const * assumptions) = 0;
}

m_solver->check_sat(0, nullptr);
```

Search `solver::check_sat`

```c++
// muz/spacer/spacer_uic_solver.cpp
lbool iuc_solver::check_sat_core(...)

// opt/opt_solver.cpp
lbool opt_solver::check_sat_core2(...)

// smt/smt_solver.cpp
lbool check_sat_core2(...)

// solver/solver.coo
lbool solver::check_sat(...) {
  check_sat_core(...)
}

// solver/tactic2solver.cpp
lbool tactic2solver::check_sat_core2(...) {

}
```

# main

```c++
// shell/main.cpp

int STD_CALL main(int argc, char ** argv)

read_smtlib2_commands(g_input_file)

// shell/<fmt_frontend.cpp>

// shell/smtlib_frontend.cpp

read_smtlib2_commands(char const * file_name)

// parser/smt2/smt2parser.cpp
parse_smt2_commands(ctx, in) {
  p()
}

bool operator()() {
  try {
    scan_core();
  }

  while (true) {
    parse_cmd();
  }
}

void parse_cmd() {
  ...
  parse_check_sat_assuming()
}

void parse_check_sat_assuming() {
  m_ctx.check_sat(expr_stack().size() - spos, expr_stack().data() + spos);
}


class parser {
    ast_manager *        m_manager;
    cmd_context &        m_ctx;
}

heading to 
// parser/smt2/smt2parser.cpp
cmd_context ctx;
ctx.set_solver_factory(mk_smt_strategic_solver_factory());

// cmd_context/cmd_context.cpp
void cmd_context::set_solver_factory(solver_factory * f) {
    if (has_manager() && f != nullptr) {
        mk_solver();
    }
}

```