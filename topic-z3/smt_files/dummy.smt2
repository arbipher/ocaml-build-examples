(declare-fun dummy () Bool)
(assert (not dummy))
(check-sat)
(get-model)