(defun extract-windows-from-tree (tree)
  (let ((retval))
    (dolist (item tree)
      (cond ((windowp item) (setq retval (cons item retval)))
            ((listp item)
             (setq retval
                   (append
                    (extract-windows-from-tree (cddr item))
                    retval)))))
    retval))

(defun get-window-sibling-recursively (win tree)
  (if (member win tree)
      (extract-windows-from-tree tree)
    (let ((tree tree)
          (retval))
      (while tree
        (let ((item (car tree)))
          (setq tree (cdr tree))
          (when (listp item)
            (setq retval (get-window-sibling-recursively win (cddr item)))
            (when retval (setq tree nil)))))
      retval)))

(defun get-window-sibling (win)
  (let ((retval)
        (frames (frame-list)))
    (while frames
      (let ((frame (car frames)))
        (setq frames (cdr frames))
        (setq retval (get-window-sibling-recursively win (window-tree frame)))
        (when retval (setq frames nil))
        ))
    retval))

(defun bubble-window (win)
  (interactive (list (selected-window)))
  (dolist (w (get-window-sibling win))
    (unless (or (eq win w)
                (window-minibuffer-p w))
      (delete-window w))))

(define-key global-map (kbd "C-x !") 'bubble-window)
