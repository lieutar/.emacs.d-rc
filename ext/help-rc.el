(require 'view)
(defconst my-rc-view-winconf nil)

(dolist (cmd '(describe-key
               describe-variable
               describe-function
               describe-face
               ))
  (eval
   `(defadvice ,cmd (around
                     my-rc-help-advices
                     activate)
      (let* ((winconf (current-window-configuration (selected-frame)))
             (retval ad-do-it))
        (unless my-rc-view-winconf
          (setq my-rc-view-winconf winconf))
        retval))))

(defun my-rc-view-mode-quit ()
  (interactive)
  (when my-rc-view-winconf
    (set-window-configuration my-rc-view-winconf)
    (setq my-rc-view-winconf nil))
  (kill-buffer (current-buffer)))

(define-key view-mode-map
  (kbd "q") 'my-rc-view-mode-quit)

