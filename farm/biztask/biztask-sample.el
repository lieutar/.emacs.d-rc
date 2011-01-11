
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(biztask
 '(
   ("web制作" :cost 1 :depends ("集金"))


   ;; 納品フェーズ
   (sequence
    ("集金")
    ("納品"       :depends ("検収"))
    ("納品書作成" :depends ("業務契約書にサイン")))


   ;; 契約フェーズ
   (sequence
    ("最終見積"          :depends ("コンテンツ確定"))
    ("業務契約書にサイン" )
    ("概算見積の了承")
    ("概算見積"      :depends ("初回ヒアリング")))
 

   ;; 制作フェーズ
   (sequence
    ("検収"         :depends ("校正" "プログラム設定"))
    ("実ページ作成" :depends ("コンテンツ内容確定"
                              "基本オーサリング"
                              "最終見積")))

   ;; プログラムフェーズ
   (sequence
    ("プログラム設定")
    ("プログラムテスト")
    ("プログラム作成" :depends ("コンテンツ確定")))

   ;;
   (sequence  
    ("校正")
    ("コンテンツ内容確定")
    ("コンテンツ確定")
    ("サイト構成確定" :depends ("初回ヒアリング")))

   ;;
   (sequence
    ("基本オーサリング")
    ("詳細デザイン"       :depends ("サイト構成確定"))
    ("基本デザイン")
    ("イメージの方向付け" :depends ("初回ヒアリング"))
    ("サンプル収集"))


   ;; コミュニケーションフェーズ
   (sequence
    ("二回目訪問" :depends (
                            "概算見積"
                            ""
                            ))
    ("初回ヒアリング" :depends ("サンプル収集"))
    )
   )
 '(
   car
   biztask:task-to-graph
   (lambda (graph) (biztask:graph:preview graph :rankdir "TB" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(let ((graph (biztask
 '(
   ("TEST"  :depends ("0" "1"))
   ("0"     :depends ("3"))
   ("1"     :depends ("3" "4"))
   ("3"     :depends ("4"))
   ("4"     :depends ())
   )
 '(
   car
   biztask:task-to-graph
;;   (lambda (graph) (biztask:graph:preview graph :rankdir "TB" :layout "dot"))
;;   biztask:graph:popup-dot
   )
 )))
  (insert (biztask:graph-to-dot graph))
  (dolist (node (biztask:graph-nodes graph))
    (insert (format  ";; %s -> %s -> %s\n"
                     (mapcar 'biztask:task-to-string (biztask:node-in node))
                     (biztask:node-id node)
                     (mapcar 'biztask:task-to-string (biztask:node-out node))
                     )))
  (biztask:graph:preview graph))


