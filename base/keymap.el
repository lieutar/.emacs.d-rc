(require 'vi)
(defconst my-km-prefix [?\C-z])
(defvar   my-ctrl-z-map nil)
(global-set-key [?\C-t] nil)
(global-set-key [?\C-x ?\C-c] nil)
(let ((km (make-sparse-keymap)))

  (define-key km [?\C-c] 'save-buffers-kill-emacs)

  (define-key km [?f]    'font-lock-fontify-buffer)
  (define-key km [?g]    'goto-line)

  (define-key km [?5]    'vi-find-matching-paren)
  (define-key km [?b]    'bury-buffer)

  (define-key km [?m]    'org-remember)
  (define-key km [?r]    'org-remember-code-reading)
  (define-key km [?t]    'org-remember-code-to-do)

  (define-key km [?\C-f] 'my-find-lib)


  (setq my-ctrl-z-map km)
  (global-set-key my-km-prefix km))


