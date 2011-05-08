;;;
(defvar elswm:temporary-frame:hide-base-frame nil)

(defun elswm:temporary-frame:open ()
  (interactive)
  (let* ((base-frame      (selected-frame))
         (original-window (selected-window))
         (winedge         (window-edges))
         (pedges          (window-pixel-edges))
         (left            (car pedges))
         (top             (cadr pedges))
         (width           (- (nth 2 winedge)(nth 0 winedge)))
         (height          (- (nth 3 winedge)(nth 1 winedge)))
         (frame
          (make-frame `((top    . ,top)
                        (left   . ,left)
                        (width  . ,width)
                        (height . ,(+ height 2))))))
    (modify-frame-parameters frame `((elswm
                                      :type      temprary
                                      :base     ,base-frame
                                      :original ,original-window)))
    (when elswm:temporary-frame:hide-base-frame
      (iconify-frame base-frame))
    (select-frame frame)
    (switch-to-buffer (window-buffer original-window))
    ))

(defun elswm:temporary-frame:close ()
  (interactive)
  (let* ((buf   (current-buffer))
         (frame (selected-frame))
         (plist (cdr (or (assq 'elswm (frame-parameters nil))(cons nil nil))))
         (ftype (plist-get plist :type ))
         (base  (plist-get plist :base )))
    (when (and (eq ftype 'temprary)
               base)
      (select-frame base)
      (make-frame-visible base)
      (switch-to-buffer buf)
      (delete-frame frame))))


(provide 'elswm-farm-commands)
