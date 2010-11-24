(defvar multident-keep-region t)
(defvar multident-depth 2)

(defun multident (begin end)
  (interactive "r")
  (goto-line (line-number-at-pos begin))
  (when multident-keep-region
    (beginning-of-line)
    (push-mark))
  (let ((to  (line-number-at-pos  end))
        (indent (make-string multident-depth
                             ?\x20)))
    (while (<= (line-number-at-pos (point)) to)
      (beginning-of-line)
      (insert indent)
      (next-line)))
  (previous-line)
  (beginning-of-line))

(defun multident-or-self-insert-command (c)
  (interactive (let ((vec (this-command-keys-vector)))
                 (list (if (> (length vec) 1)
                           (string (aref [? ] 0))
                         " "))))
  (if mark-active
      (multident (region-beginning)
                 (region-end))
    (insert c)))

(global-set-key (kbd "SPC") 'multident-or-self-insert-command)  





