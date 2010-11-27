;;; cygwin を使う各種 windows 系の設定

(setq shell-file-name "zsh.exe")
(setq explicit-shell-file-name "zsh.exe")
(setenv "SHELL" "zsh")

(setq shell-command-switch "-c")
(modify-coding-system-alist
 'process ".*sh\\.exe" '(undecided-dos . utf-8-unix))

;; This removes unsightly ^M characters that would otherwise
;; appear in the output of java applications.
(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)

(rc-emacsen-case
    (meadow-nt-@
     (require 'mw32script)
     (mw32script-init)
     (setq exec-suffix-list '(".exe" ".sh" ".pl"))
     (setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.:()-")
     ))


;;;
;;; SEE ALSO
;;; http://www.emacswiki.org/emacs/NTEmacsWithCygwin
;;;
