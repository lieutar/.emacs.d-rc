
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(biztask
 '(
   ("web制作" :cost 1 :depends ("集金"))


   ;; コミュニケーショングループ
   (sequence
    ("初回ヒアリング" :depends ("サンプル収集"))
    ("二回目訪問"     :depends ("概算見積"))
    )



   ;; 契約グループ
   (sequence
    ("概算見積"
     :depends ("初回ヒアリング")
     )
    ("概算見積の了承")
    ("業務契約書にサイン" )
    ("最終見積"          :depends ("コンテンツ確定"))
    )

   ;; 納品グループ
   (sequence
    ("納品書作成" :depends ("業務契約書にサイン"))
    ("納品"       :depends ("検収"))
    ("集金"))



   ;; コンテンツグループ
   (sequence  
    ("サイト構成確定" :depends ("初回ヒアリング"))
    ("コンテンツ確定")
    ("コンテンツ内容確定")
    ("校正")
    )

   ;; デザイングループ
   (sequence
    ("サンプル収集")
    ("基本デザイン"  :depends ("初回ヒアリング"))
    ("詳細デザイン"  :depends ("サイト構成確定"))
    )


   ;; 制作フェーズ
   (sequence
    ("基本オーサリング" :depends ("詳細デザイン"))
    ("実ページ作成" :depends ("最終見積"))
    ("検収"         :depends ("校正" "プログラム設定"))
    )

   ;; プログラムフェーズ
   (sequence
    ("プログラム作成"   :depends ("コンテンツ確定"))
    ("プログラムテスト" )
    ("プログラム設定"   )
    )

   )
 '(
   car
   biztask:task-to-graph
   (lambda (graph) (biztask:graph:preview graph :rankdir "TB" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )
