;;; cygwin を使う各種 windows 系の設定

(setq explicit-shell-file-name "zsh.exe")
(setq shell-file-name          "sh.exe")
(setq shell-command-switch    "-c")
(setenv "SHELL" "zsh")
(modify-coding-system-alist 'process ".*sh\\.exe" '(undecided-dos . utf-8-unix))
;; This removes unsightly ^M characters that would otherwise
;; appear in the output of java applications.
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)



;;;
;;; SEE ALSO
;;; http://www.emacswiki.org/emacs/NTEmacsWithCygwin
;;;
