(require 'cl)

(defconst setup-my-working-environment-confirm-buffer nil)
(defconst setup-my-working-environment-confirm-timer  nil)

(defun setup-my-working-environment ()
  (if (> (x-display-pixel-width) 800)
      (progn
        (modify-frame-parameters (selected-frame) '((width  . 166)))
        (my-rc-wide-screen-envronment))
    (progn
      (my-rc-narrow-screen-environment))))


(defconst setup-my-working-environment-confirm-mode-map
  (let ((km (make-sparse-keymap)))
    (define-key km (kbd "n") 'setup-my-working-environment-confirm-n)
    (define-key km (kbd "y") 'setup-my-working-environment-confirm-y)
    km))

(defun setup-my-working-environment-confirm-n ()
  (interactive)
  (kill-buffer setup-my-working-environment-confirm-buffer)
  (cancel-timer
   setup-my-working-environment-confirm-timer))

(defun setup-my-working-environment-confirm-y ()
  (interactive)
  (kill-buffer setup-my-working-environment-confirm-buffer)
  (setup-my-working-environment)
  (cancel-timer
   setup-my-working-environment-confirm-timer))

(define-derived-mode setup-my-working-environment-confirm-mode
  fundamental-mode "setup-my-working-environment-confirm-mode"
  (setq buffer-read-only t))

(defun setup-my-working-environment-confirm ()
  (let ((buf    (get-buffer-create "*setup-my-working-environment*"))
        (height (cdr (assq 'height (frame-parameters (selected-frame))))))
    (setq setup-my-working-environment-confirm-buffer buf)
    (switch-to-buffer buf)
    (loop for c from 1 to (- (/ (- height 2) 2) 2) do
          (insert "\n"))
    (insert (format  "Hello %s !!" user-login-name) "\n"
            "Do you want to build your usual environment? (Y / n) :")
    (setup-my-working-environment-confirm-mode)
    (setq setup-my-working-environment-confirm-timer
          (run-at-time "5 sec" nil
                       'setup-my-working-environment-confirm-y))))

(add-hook 'after-init-hook 'setup-my-working-environment-confirm)
