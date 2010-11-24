
(setq shell-file-name "zsh.exe")
(setenv "SHELL" "zsh")

(setq explicit-shell-file-name shell-file-name) ; Interactive shell
(setq ediff-shell shell-file-name)      ; Ediff shell
(setq explicit-shell-args '("--login" "-i"))
;;;;; (setq shell-command-switch "-ic") ; SHOULD THIS BE "-c" or "-ic"?
;; " @@@ IS THIS BETTER? ;@@@ WAS THIS BEFORE: (setq w32-quote-process-args t)
(setq w32-quote-process-args ?\")


(setq shell-command-switch "-c")
(modify-coding-system-alist
 'process ".*sh\\.exe" '(undecided-dos . utf-8-unix))

;; This removes unsightly ^M characters that would otherwise
;; appear in the output of java applications.
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
;; (setq comint-output-filter-functions (cdr comint-output-filter-functions))
;; (setq comint-output-filter-functions (cdr comint-output-filter-functions))

;;;
;;; SEE ALSO
;;; http://www.emacswiki.org/emacs/NTEmacsWithCygwin
;;;
