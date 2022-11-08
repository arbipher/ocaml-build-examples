Z3_SRC = z3
JOBS = 12
SRC = via_terminal
# prepare dev directory

include Makefile.weird.mk

local-opam:
	opam switch create ./ 4.14.0
	opam repo add my_opam https://github.com/arbipher/opam-repository.git
	opam install zarith conf-gmp conf-python-3 conf-c++

local-dev:
	opam install utop ocamlformat ocaml-lsp-server

local-z3:
	# git clone https://github.com/Z3Prover/z3.git
	git submodule add https://github.com/Z3Prover/z3.git
	# opam pin add vendor/z3 --dev-repo
	# opam: bad package format

# from opam
build-z3-1:
	cd $(Z3_SRC) && python3 scripts/mk_make.py --debug --ml

build-z3-2:
	cd $(Z3_SRC) && make -C build -j $(JOBS)

install-z3:
	ocamlfind install z3 $(Z3_SRC)/build/api/ml/* -dll $(Z3_SRC)/build/libz3.*

remove-z3:
	ocamlfind remove z3

# build z3 with static lib

ifeq ($(shell uname),Darwin)
    LDD := otool -L
else
    LDD := ldd
endif

# build z3 with shared lib

z3-opt:
	ocamlfind ocamlopt -o $(SRC)/z2.exe -verbose -thread -package z3 -linkpkg $(SRC)/z1.ml
	./$(SRC)/z2.exe

z3-opt-show:
	$(LDD) $(SRC)/z2.exe | grep z3

z3-bc:
	ocamlfind ocamlc -o $(SRC)/z2.bc -verbose -thread -package z3 -linkpkg $(SRC)/z1.ml
	./$(SRC)/z2.bc

z3-bc-show:
	ocamlobjinfo $(SRC)/z2.bc | grep 'Used DLL' -A5

z3-bcc:
	ocamlfind ocamlc -o $(SRC)/z2c.bc -verbose -custom -thread -package z3 -linkpkg $(SRC)/z1.ml
	./$(SRC)/z2c.bc

z3-bcc-show:
	ocamlobjinfo $(SRC)/z2c.bc | grep 'Used DLL' -A5 || true

# dune project test

z3-test-dune:
	dune build @sudu-test

# debug note (already fixed)
#

# 1. when lost runtime sharedlib search path

# opt build ok
# run `export LD_LIBRARY_PATH=/path/to/(libz3.so)` to run
# or
z3-shared-opt-fix:
	ocamlfind ocamlopt -o z2-fix.exe -verbose -thread -package z3 -linkpkg -ccopt -Wl,-rpath,$$(opam var stublibs) z1.ml

# bc build fail
z3-shared-bc-fix:
	ocamlfind ocamlc -o z2-fix.bc -verbose -thread -package z3 -linkpkg -dllpath $$(opam var stublibs) z1.ml

# 2. inspect z3 package

z3-shared-info:
	ocamlobjinfo $$(opam var z3:lib)/z3ml.cma

z3-static-info:
	ocamlobjinfo $$(opam var z3-static:lib)/z3ml.cmxa

z3-shared-stub-info:
	$(LDD) $$(opam var lib)/stublibs/dllz3ml.so

z3-static-stub-info:
	$(LDD) $$(opam var lib)/stublibs/dllz3ml-static.so

# 3. play on llvm for comparison

llvm-static-opt:
	ocamlfind ocamlopt -verbose -o m2.exe -predicates llvm.static -package llvm.target -linkpkg m1.ml
	./m2.exe

llvm-static-opt-show:
	$(LDD) m2.exe | grep LLVM || echo "NONE"
	
llvm-static-bc:
	ocamlfind ocamlc -verbose -o m2.bc -predicates llvm.static -package llvm.target -linkpkg m1.ml
	./m2.bc

llvm-static-bc-show:
	ocamlobjinfo m2.bc | grep 'Used DLL' -A5 || echo "NONE"

llvm-static-bcc:
	ocamlfind ocamlc -verbose -o m2c.bc -custom -predicates llvm.static -package llvm.target -linkpkg m1.ml
	./m2c.bc

llvm-static-bcc-show:
	ocamlobjinfo m2c.bc | grep 'Used DLL' -A5 || echo "NONE"

llvm-shared-opt:
	ocamlfind ocamlopt -o m1.exe -verbose -package llvm.target -linkpkg m1.ml
	./m1.exe

llvm-shared-opt-show:
	$(LDD) m1.exe | grep LLVM

llvm-shared-bc:
	ocamlfind ocamlc -o m1.bc -package llvm.target -linkpkg m1.ml
	./m1.bc

llvm-shared-bc-show:
	ocamlobjinfo m1.bc | grep 'Used DLL' -A5 | grep dllllvm

llvm-shared-bcc:
	ocamlfind ocamlc -o m1c.bc -custom -package llvm.target -linkpkg m1.ml
	./m1c.bc

llvm-shared-bcc-show:
	ocamlobjinfo m1c.bc | grep 'Used DLL' -A5 | grep dllllvm || echo "NONE"

# 4. inspect llvm package

llvm-meta-info:
	cat $$(opam var lib)/META.llvm

llvm-shared-info:
	ocamlobjinfo $$(opam var llvm:lib)/shared/llvm_target.cma

llvm-static-info:
	ocamlobjinfo $$(opam var llvm:lib)/static/llvm_target.cma

llvm-stub-info:
	$(LDD) $$(opam var lib)/stublibs/dllllvm.so

# Obsolete: Z3-OCaml has no static library

z3-static-opt:
	ocamlfind ocamlopt -verbose -o z1.exe -thread -package z3-static -linkpkg /z1.ml
	./z1.exe

z3-static-opt-show:
	$(LDD) z1.exe | grep z3 || echo "NONE"

z3-static-bc:
	ocamlfind ocamlc -verbose -o z1.bc -thread -package z3-static -linkpkg z1.ml
	./z1.bc

z3-static-bc-show:
	ocamlobjinfo z1.bc | grep 'Used DLL' -A5

z3-static-bcc:
	ocamlfind ocamlc -verbose -o z1c.bc -custom -thread -package z3-static -linkpkg z1.ml
	./z1c.bc

z3-static-bcc-show:
	ocamlobjinfo z1c.bc | grep 'Used DLL' -A5 || echo "NONE"