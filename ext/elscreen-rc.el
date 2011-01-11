(rc-ext
 :class 'window-manager
 :name  'elscreen
 :load  'elscreen

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


   (define-key elscreen-map (kbd "C-c") 'elsp:create)

   (defun my-rc-3cols-environment ()
     (require 'elsp)
     (rc-load "myenv-elscreen-3cols")
     (elsp:after-goto))

   (defun my-rc-wide-screen-environment ()
     (require 'elsp)
     (rc-load "myenv-elscreen-wide")
     (elsp:after-goto))

   (defun my-rc-narrow-screen-environment ()
     (require 'elsp)
     (rc-load "myenv-elscreen-narrow")
     (elsp:after-goto))
   ))

