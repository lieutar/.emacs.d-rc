(defun kill-other-emacses ()
  (interactive)
  (dolist
      (line (split-string (shell-command-to-string
                           (format "ps aux|grep emacs|grep -v grep|grep -v %s"
                                   (emacs-pid))
                           )
                          "\n"))
    (when (string-match "[^ \t]" line)
      (let* ((fields (split-string line "\\s +"))
             (pid    (nth 1 fields)))
        (shell-command (format "kill -KILL %s" pid))))
    ))