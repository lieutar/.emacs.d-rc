
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

;; 俺々スクリプト置き場にパスを通す
(setq load-path

      (append
       (apply
        'append
        (mapcar
         (lambda (work)
           (when (file-readable-p work)
             (apply 'append
                    (list work)
                    (mapcar
                     (lambda (file)
                       (unless (string-match "^\\.+$" file)
                         (let ((full (expand-file-name
                                      (concat work "/" file))))
                           (when (file-directory-p full)
                             (list full)))))
                     (directory-files work)))))
         (list
          (expand-file-name "~/share/emacs/site-lisp")
          (expand-file-name "~/work/emacs")
          )))

       load-path))

;; 俺々スクリプトで拡張の自動インストールとかできるようにする
(require 'rc-ext)


(rc-emacsen-case
    (fsf-cygwin-@
     ;; なぜか、user/local/share/site-lisp にデフォルトでパスが通っていない
     ;; cygwin のために
     (save-excursion
       (let ((buf (find-file "/usr/local/share/emacs/site-lisp/subdirs.el")))
         (eval-buffer buf)
         (kill-buffer buf)))))
