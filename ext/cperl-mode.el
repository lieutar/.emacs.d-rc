(rc-ext
 :load 'cperl-mode
 :get  (lambda ()
         (browse-url "http://math.berkeley.edu/~ilya/software/emacs/"))
 :preload
 (lambda ()
   (defalias 'perl-mode 'cperl-mode)
   (setq auto-mode-alist
         (append
          '(
            ("t/[^/]*\\.t\\'" . cperl-mode)
            )
          auto-mode-alist))
   )
 :init
 (lambda ()

   ;; http://d.hatena.ne.jp/antipop/20080702/1214926316
   ;; perldoc -m を開く

   ;; モジュールソースバッファの場合はその場で、
   ;; その他のバッファの場合は別ウィンドウに開く。
   (put 'perl-module-thing 'end-op
        (lambda ()
          (re-search-forward "\\=[a-zA-Z][a-zA-Z0-9_:]*" nil t)))
   (put 'perl-module-thing 'beginning-op
        (lambda ()
          (if (re-search-backward "[^a-zA-Z0-9_:]" nil t)
              (forward-char)
            (goto-char (point-min)))))

   (defun perldoc-m (module)
     (interactive (list (thing-at-point 'perl-module-thing)))
     (let ((pop-up-windows t)
           (cperl-mode-hook nil))
       (when (string= module "")
         (setq module (read-string "Module Name: ")))
       (let ((result (substring (shell-command-to-string
                                 (concat "perldoc -m " module)) 0 -1))
             (buffer (get-buffer-create (concat "*Perl " module "*")))
             (pop-or-set-flag (string-match "*Perl " (buffer-name))))
         (if (string-match "No module found for" result)
             (message "%s" result)
           (progn
             (with-current-buffer buffer
               (toggle-read-only -1)
               (erase-buffer)
               (insert result)
               (goto-char (point-min))
               (cperl-mode)
               (toggle-read-only 1)
               )
             (if pop-or-set-flag
                 (switch-to-buffer buffer)
               (display-buffer buffer)))))))

   ))


