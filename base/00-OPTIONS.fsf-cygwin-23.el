(save-excursion
  (let ((buf (find-file "/usr/local/share/emacs/site-lisp/subdirs.el")))
    (eval-buffer buf)
    (kill-buffer buf)))

