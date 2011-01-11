
;; Hi! I am Japanese!!
(set-language-environment 'Japanese)
(set-time-zone-rule       "GMT -9")

;; 昔は EUC にしてたもんです
(set-default-coding-systems   'utf-8)


;; ~ ファイルいりません
(setq-default make-backup-files nil)

;; tab とかでインデントする奴逝って良し
(setq-default indent-tabs-mode nil)

;; スプラッシュ、まぁ嫌いじゃないんですけど、いらない
(setq inhibit-startup-message t) 

;; 1にしたのになぜか 半分ずつスクロールしちゃうの
(setq scroll-step 1)

;; ないと死ねる
(show-paren-mode     t)

;; リージョンに色づけされるので萌える
(transient-mark-mode t)
