(setq truncate-lines nil
      truncate-partial-width-windows nil)

(defun toggle-truncate-lines ()
  "折り返し表示をトグル動作します."
  (interactive)
  (let ((toggled (not truncate-lines)))
    (setq truncate-lines                 toggled)
    (setq truncate-partial-width-windows toggled))
  (recenter))


(global-set-key "\C-c\C-l" 'toggle-truncate-lines) 
