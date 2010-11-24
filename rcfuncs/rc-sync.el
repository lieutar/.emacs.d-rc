(defvar rc-sync-file (expand-file-name
                      (format "%s/sync.sexp" rc-directory)))

(defvar rc-sync-files-services
  (list "http://www.kael/~lieutar/emacs/rc/index.php?mode=list"))


(defvar rc-sync-options nil)

(defun rc-sync-save-options ()
  (with-temp-buffer
    (insert (format "%S" rc-sync-options))
    (setq buffer-file-name rc-sync-file)
    (save-buffer)))

(defun rc-sync-load-options ()
  (save-excursion
    (let ((buf (find-file rc-sync-file)))
      (set-buffer buf)
      (setq rc-sync-options
            (read (buffer-substring-no-properties
                   (point-min) (point-max))))
      (kill-buffer buf))))

(defun rc-sync-load-files-list ()
  (let ((buf (url-retrieve-synchronously
              rc-sync-files-list-url))
        (R   nil))
    (save-excursion
      (set-buffer buf)
      (re-search-forward "^$" nil t nil)
      (setq R (read (buffer-substring-no-properties (point)(point-max))))
      (kill-buffer buf)
      R)))


(defun rc-sync-reset-options ()
  (interactive)
  (setq rc-sync-options nil)
  (rc-sync-save-options))

(defun rc-sync ()
  (interactive)
  (dolist (slot (rc-sync-load-file-list))
    (let* ((file  (car slot))
           (plist (cdr slot))
           (mtime (plist-get plist 'mtime))
           (url   (plist-get plist 'url)))
      )))

