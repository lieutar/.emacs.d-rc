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

        (defconst my-elscreen-initialized-flags (make-hash-table :test 'eq))

        (defconst my-elscreen-background-color-list
          '(("#554433" . "#F8F8F0")
            ("#335566" . "#F0FCFC")
            ("#000000" . "#FFFFFF")))

        (defun my-elscreen-after-goto ()
          (unless (gethash screen my-elscreen-initialized-flags)

            ;;(sr-speedbar-open)
            ;;(other-window 1)
            (split-window-vertically (- (frame-parameter (selected-frame)
                                                         'height)
                                        10))
            (other-window 1)
            (switch-to-buffer "*scratch*")
            (other-window 1)
            (split-window-horizontally)

            (puthash screen t my-elscreen-initialized-flags)
            )
          (modify-frame-parameters
           (selected-frame)
           (let ((color (nth (min
                              (1- (length  my-elscreen-background-color-list))
                              screen)
                             my-elscreen-background-color-list)))
             `((foreground-color . ,(car color))
               (background-color . ,(cdr color))))))

        (add-hook 'elscreen-goto-hook 'my-elscreen-after-goto)

        (defun my-elscreen-after-kill ()
          (puthash screen nil my-elscreen-initialized-flags))
        (add-hook 'elscreen-kill-hook 'my-elscreen-after-kill)
        ;;elscreen-kill-hook

        (let ((screen 0)) (my-elscreen-after-goto))
        (twit)
        (other-window 1)
        (twittering-visit-timeline ":mentions")

        (elscreen-create)
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
          
        (elscreen-next)
        (elscreen-next)
        )
   
       ((<= 90 width)
        (twit)
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
