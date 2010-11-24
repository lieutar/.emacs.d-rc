(defun copy-buffer-file-name ()
  (interactive)
  (if buffer-file-name (kill-new buffer-file-name)))