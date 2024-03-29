
readfile:
	dune build via_dune/bin/read_file.exe
	
bad: readfile
	./read_file.exe weird_case/bad.smt2

good:
	./read_file.exe weird_case/good.smt2

dummy:
	./read_file.exe weird_case/dummy.smt2

utop:
	dune utop

trace:
	strace -k z3/build/z3 weird_case/dummy.smt2 2>trace.log

truss:
	sudo dtruss -s z3 weird_case/partial.smt2 2> trace.log

write:
	dune runtest --auto-promote || true
