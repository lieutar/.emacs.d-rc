(rc-ext

 :class 'window-manager

 :name  'elscreen

 :load 'elscreen

 :preload
 (lambda ()
   (setq elscreen-prefix-key (kbd "C-t"))
   (setq elscreen-display-tab nil)
   )

 :get
 (lambda ()
   (browse-url
    "http://www.morishima.net/~naoto/software/elscreen/index.php.ja"))

 :init
 (lambda ()
   (define-key elscreen-map (kbd "<SPC>") 'elscreen-next)

   (defun elscreen-frame-title-update ()
     (when (elscreen-screen-modified-p 'elscreen-frame-title-update)
       (let* ((screen-list          (sort (elscreen-get-screen-list) '<))
              (screen-to-name-alist (elscreen-get-screen-to-name-alist))
              (title (mapconcat
                      (lambda (screen)
                        (if (equal "+" (elscreen-status-label screen))
                            (format "%d %s"
                                    screen
                                    (get-alist screen screen-to-name-alist))
                          (format "%d" screen)
                          ))
                      screen-list
                      "|"
                      )))
         (if (fboundp 'set-frame-name)
             (set-frame-name title)
           (setq frame-title-format title)))))

   (add-hook 'elscreen-screen-update-hook 'elscreen-frame-title-update)

   (when (locate-library "anything-config")

     (defun my-rc-anything-elscreen ()
       (interactive)
       (anything 'anything-c-source-elscreen)
       nil nil nil nil "*elscreen*")

     (define-key elscreen-map (kbd"C-t") 'my-rc-anything-elscreen))


   (defun my-rc-wide-screen-envronment ()

     (interactive)

     (defconst my-elscreen-initialized-flags (make-hash-table :test 'eq))
     (defconst my-elscreen-background-color-list
       '(("#554433" . "#F8F8F0")
         ("#335566" . "#F0FCFC")
         ("#000000" . "#FFFFFF")))
    
     (defun my-elscreen-after-goto ()
      
       (unless (gethash screen my-elscreen-initialized-flags)
         (split-window-horizontally)      
         (puthash screen t my-elscreen-initialized-flags))
      
       (modify-frame-parameters
        (selected-frame)
        (let ((color (nth (min
                           (1- (length  my-elscreen-background-color-list))
                           screen)
                          my-elscreen-background-color-list)))
          `((foreground-color . ,(car color))
            (background-color . ,(cdr color)))))
       )
    
     (add-hook 'elscreen-goto-hook 'my-elscreen-after-goto)
    
     (defun my-elscreen-after-kill ()
       (puthash screen nil my-elscreen-initialized-flags))
     
     (add-hook 'elscreen-kill-hook 'my-elscreen-after-kill)
    
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
            (re-search-forward "^\\*\\* Active" nil t)))
     (other-window 1)
     (display-about-screen)
     (split-window-vertically 22)
     
     (when (fboundp 'find-git)
       (setq find-git-popup-find-git-mode-buffer t)
       (setq find-git-mode-reflesh nil)
       (let ((find-git-popup-find-git-mode-buffer nil)
             (find-git-mode-reflesh t))
         (find-git "~" :popup-to-current-window t)))
     
     (other-window 1)
     (other-window 1)
     
     (elscreen-create)
     
     (elscreen-next)
     (elscreen-next))
 
   
   (defun my-rc-narrow-screen-environment ()
     (twit)
     (elscreen-create)
     (split-window-horizontally 85)
     (elscreen-create))
   ))
