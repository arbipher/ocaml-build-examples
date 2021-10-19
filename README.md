Currently, it's just some random notes.

# reference

on stublib
https://discuss.ocaml.org/t/what-is-using-shared-stublibs/4638

# how to find the shared.so

1. set rpath at library building time
1.a hacking `lib.so` building
no works

1.b hacking `.cm{a,s,xs}` building

2. set rpath at client buildingtime
add to `META`

```
linkopts = "-ccopt -Wl,-rpath,/home/exx/.opam/4.12.0.many/lib/stublibs"
```

It works for opt but not bc.
Understandable. In opt the linker regards this rpath, however; in bc. the lib is dynamic loaded without a linking stage.

3. set dllpath
`ocamlc ... -dllpath $$(opam var stublibs)`
It works for bc but not opt.

Understandable. 

4. set `LD_LIBRARY_PATH`
It works for both bc and opt.

Understandable.

Impression: `ocamlmklib` and `ocamlfind` can work separately. There must be one place to telling the path of shared lib to the final binary.



```shell
$ make api/ml/z3ml.cma
ocamlmklib -o api/ml/z3ml -I api/ml -L. api/ml/z3native_stubs.o api/ml/z3enums.cmo api/ml/z3native.cmo api/ml/z3.cmo  -lz3-static -lstdc++
```

This will gen `dllz3ml.so` and `libz3ml.a`