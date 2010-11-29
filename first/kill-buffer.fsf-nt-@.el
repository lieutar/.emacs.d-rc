;;; ntemacs で、なんか引数なしの kill-buffer が使えなかったので

(unless (fboundp 'kill-buffer-ntemacs-original)
  (fset 'kill-buffer-ntemacs-original (symbol-function 'kill-buffer)))

(defun kill-buffer (&rest args)
  (interactive "b")
  (apply 'kill-buffer-ntemacs-original
         (or args (list (current-buffer)))))


