
(set-logic HORN)
;(set-option :fp.engine.inline_linear "spacer")
;(set-option :fp.spacer.gpdr "true")
(set-option :fp.xform.inline_linear false)
(set-option :fp.xform.inline_eager false)

(declare-fun Inv (Int) Bool)
(assert (Inv 0))
(assert (forall ((x Int)) (=> (<= x 0) (Inv x))))
(assert (forall ((x Int)) (=> (< x 5) (Inv (+ x 1)))))
;(assert (forall ((x Int)) (=> (and (Inv x) (>= x 5) (>= x 10)) false))) ; works
;; (assert (forall ((x Int)) (=> (and (Inv x) (>= x 5) (= x 10)) false))) ; this doesn't (solution not as precise)
(check-sat)
(get-model)
(eval (Inv 0))
(eval (Inv 4))
(eval (Inv 10))