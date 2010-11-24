
(setq shell-file-name "zsh.exe")
(setq explicit-shell-file-name "zsh.exe")
(setenv "SHELL" "zsh")

(setq shell-command-switch "-c")
(modify-coding-system-alist
 'process ".*sh\\.exe" '(undecided-dos . utf-8-unix))

;; This removes unsightly ^M characters that would otherwise
;; appear in the output of java applications.
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

;;;
;;; SEE ALSO
;;; http://www.emacswiki.org/emacs/NTEmacsWithCygwin
;;;
