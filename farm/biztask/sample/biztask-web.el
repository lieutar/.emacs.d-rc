
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(biztask
 '(
   ("web制作" :depends ("集金"))


   ;; コミュニケーショングループ
   (sequence
    ("初回ヒアリング"
     :depends ("サンプル収集" "契約サンプルの準備")
     :cost    1)
    ("二回目訪問"
     :depends ("概算見積")
     :cost    1)
    )



   ;; 契約グループ
   ("契約サンプルの準備"
    :cost 0.25
    )

   (sequence
    ("概算見積" :depends ("初回ヒアリング")
     :cost    0.25
     )

    ("概算見積の了承"
     :depends ("二回目訪問")
     :cost 0)

    ("業務契約書にサイン" 
     :cost 0)

    ("最終見積"          :depends ("コンテンツ確定")
     :cost 0.25)

    ("最終見積の承認"
     :cost 0.25)

    ("納品書作成"
     :cost 0.25)

    ("納品"       :depends ("検収")
     :cost 1)
    ("集金"
     :cost 1))



   ;; コンテンツグループ
   (sequence  
    ("サイト構成確定" :depends ("初回ヒアリング")
     :cost 0.25
     )
    ("コンテンツ確定"
     :cost 1
     )
    ("コンテンツ内容確定"
     :cost 10
     )
    ("校正"
     :cost 5)
    )

   ;; デザイングループ
   (sequence
    ("サンプル収集"
     :cost 1)
    ("基本デザイン"  :depends ("初回ヒアリング")
     :cost 3)
    ("詳細デザイン"  :depends ("サイト構成確定")
     :cost 5)
    )


   ;; 制作フェーズ
   (sequence
    ("基本オーサリング" :depends ("詳細デザイン")
     :cost 5)
    ("実ページ作成"     :depends ("最終見積")
     :cost 5)
    ("検収"             :depends ("校正" "プログラム設定")
     :cost 1)
    )

   ;; プログラムフェーズ
   (sequence
    ("プログラム作成"   :depends ("コンテンツ確定")
     :cost 2)
    ("プログラムテスト" 
     :cost 2)
    ("プログラム設定" 
     :cost 1)
    )

   )
 '(
   car
   biztask:task-to-graph
   (lambda (graph) (biztask:graph:preview graph :rankdir "LR" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )
