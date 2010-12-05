(require 'cl)

(defconst setup-my-working-environment-confirm-buffer nil)
(defconst setup-my-working-environment-confirm-timer  nil)

(defun setup-my-working-environment ()

  (rc-emacsen-case
   (@-nt-@
    ;;(modify-frame-parameters (selected-frame) '((width  . 203)))
    (modify-frame-parameters (selected-frame) '((width  . 166)))
    ;;(assoc 'width (frame-parameters (selected-frame)))
    ;;(assoc 'height (frame-parameters (selected-frame)))
    ))

  (when (fboundp 'elscreen-create)
    (let ((width (cdr (assq 'width
                            (frame-parameters (selected-frame))))))
      (cond
       ((<= 166 width)

        (twit)
        (split-window-horizontally)
        (other-window 1)
        (twittering-visit-timeline ":mentions")

        (elscreen-create)
        (split-window-horizontally)
        (when (file-readable-p "~/memo/agenda.org")
          (find-file  "~/memo/agenda.org")
          (and (re-search-forward "^\\*\\* Log" nil t)
               (progn
                 (beginning-of-line)
                 (condition-case nil
                     (progn
                       (call-interactively 'org-cycle)
                       t)
                   (error)))
               (re-search-forward "^\\*\\* Active" nil t)
               ))
        (other-window 1)
        (display-about-screen)
        (split-window-vertically 22)
        (when (fboundp 'find-git)
          (setq find-git-popup-find-git-mode-buffer t)
          (setq find-git-mode-reflesh nil)
          (let ((find-git-popup-find-git-mode-buffer nil)
                (find-git-mode-reflesh t))
            (find-git "~" :popup-to-current-window t)
            ))
        (other-window 1)
        (other-window 1)
          
        (elscreen-create)
        (split-window-horizontally)

        (elscreen-create)
        (split-window-horizontally)
          
        (elscreen-next)
        (elscreen-next)
        )
   
       ((<= 90 width)
        (elscreen-create)
        (split-window-horizontally 85)
        (elscreen-create)
        (split-window-horizontally 85)
        (elscreen-create)
        (split-window-horizontally 85)
        (elscreen-next))))))

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
