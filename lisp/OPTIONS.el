
;; Hi! I am Japanese!!
(set-language-environment 'Japanese)
;;(set-time-zone-rule       "GMT +9")

;;; 東京
(setq calendar-latitude 35.35)
(setq calendar-longitude 139.44)
(setq calendar-location-name "Tokyo, jp")
;;; 日本
(setq calendar-time-zone +540)
(setq calendar-standard-time-zone-name "JST")
(setq calendar-daylight-time-zone-name "JST")


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
