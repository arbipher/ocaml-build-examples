
readfile:
	dune build via_dune/bin/read_file.exe
	
bad: readfile
	./read_file.exe weird_case/bad.smt2

good:
	./read_file.exe weird_case/good.smt2

utop:
	dune utop