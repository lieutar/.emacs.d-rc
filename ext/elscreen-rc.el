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

   (defconst my-elscreen-background-color-list  '(("#000000" . "#FFFFFF")))

   (defconst my-elscreen-initialized-flags (make-hash-table :test 'eq))

   (defconst my-elscreen-initialize-function (lambda ()))

   (defun my-elscreen-after-goto ()
     (unless (gethash screen my-elscreen-initialized-flags)
       (funcall my-elscreen-initialize-function)
       (puthash screen t my-elscreen-initialized-flags)))

   (add-hook 'elscreen-goto-hook 'my-elscreen-after-goto)
    
   (defun my-elscreen-after-kill ()
     (puthash screen nil my-elscreen-initialized-flags))

   (add-hook 'elscreen-kill-hook 'my-elscreen-after-kill)

   (defun my-elscreen-modify-frame-color ()
     (modify-frame-parameters
      (selected-frame)
      (let* ((color (nth (min
                          (1- (length  my-elscreen-background-color-list))
                          (elscreen-get-current-screen))
                         my-elscreen-background-color-list)))
        `((foreground-color . ,(car color))
          (background-color . ,(cdr color))))))

   (add-hook 'elscreen-screen-update-hook 'my-elscreen-modify-frame-color)

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

   (rc-load "elscreen-environment")
   ))
