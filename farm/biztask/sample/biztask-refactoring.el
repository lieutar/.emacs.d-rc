(require 'biztask)
(biztask
 '((sequence
    ("関数、オブジェクトのドメイン分け")
    ("ドエミンごとのインターフェイスの統一")
    ("ドメインごとのOO化")
    ("初期リファクタリング")))
 '(car
   biztask:task-to-graph
   biztask:graph:preview))