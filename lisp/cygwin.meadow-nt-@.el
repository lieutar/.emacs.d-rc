
(setq shell-file-name "zsh.exe")
(setq explicit-shell-file-name "zsh.exe")
(setq shell-command-switch "-c")
(modify-coding-system-alist
 'process ".*sh\\.exe" '(undecided-dos . utf-8-unix))

(require 'mw32script)
(mw32script-init)
(setq exec-suffix-list '(".exe" ".sh" ".pl"))
(setq shell-file-name-chars "~/A-Za-z0-9_^$!#%&{}@`'.:()-")

