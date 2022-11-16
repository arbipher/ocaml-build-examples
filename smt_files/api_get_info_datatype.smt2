(declare-fun f (Int) Int)
(assert (= (f 10) 1))

(declare-datatypes (T) ((Option none (Some (val T)) )))
(declare-fun g (Int) (Option Int))
(assert (=  (g 1) (Some 3)))
(assert (=  (g 2) none))
(check-sat)
(get-model)