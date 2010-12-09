(rc-ext
 :load (lambda () (load "js2-20090723b"))
 :get  "http://js2-mode.googlecode.com/files/js2-20090723b.el"
 :preload (lambda ()
            (setq auto-mode-alist
                  (cons '("\\.js\\'" . js2-mode)
                        auto-mode-alist))
            )
 :autoload 'js2-mode
 :init
 (lambda ()


   (defun myconfig-js2-mode-hook ()
     (setq js2-basic-offset 2)
     (setq tab-width 4)
     ;; C-mでインデントしないように
     (setq js2-enter-indents-newline nil)
     ;; (, { とかを入力した際，対応する括弧とかを自動的に挿入しない。
     (setq js2-mirror-mode nil)
     (mapcar 'local-unset-key '("(" ")"
                                "{" "}"
                                "[" "]"
                                "\"" "'" ":" ";" "," [?\C-m]))
     )

   (add-hook 'js2-mode-hook 'myconfig-js2-mode-hook)
   (global-unset-key (kbd "<f5>"))))
