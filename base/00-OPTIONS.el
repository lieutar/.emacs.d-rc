
;; Hi! I am Japanese!!
(set-language-environment     'Japanese)

;; 昔は EUC にしてたもんです
(set-default-coding-systems   'utf-8-unix)

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

;; 各所にパスを通す
(let ((subdirs (locate-library "subdirs.el")))
  (dolist (default-directory
            (append
             '("~/share/emacs/site-lisp"
               "~/work/emacs")
             (rc-emacsen-case
              (fsf-cygwin-@
               ;; なぜか、user/local/share/site-lisp に
               ;; デフォルトでパスが通っていない
               ;; cygwin のために
               '("/usr/local/share/emacs/site-lisp")))))
    (unless (file-exists-p "./subdirs.el")
      (copy-file subdirs "./subdirs.el"))
    (add-to-list 'load-path (expand-file-name default-directory))
    (load "./subdirs.el")))

;; 拡張設定用ライブラリの読み込み
(require 'rc-ext)

