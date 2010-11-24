(rc-ext
 :class 'window-manager
 :name  'elscreen
 :load (lambda ()
         (require 'elscreen)
         (require 'elscreen-color-theme))
 :preload
 (lambda ()
   (setq elscreen-prefix-key (kbd "C-t"))
   )
 :get
 (lambda ()
   (browse-url
    "http://www.morishima.net/~naoto/software/elscreen/index.php.ja"))
 :init
 (lambda ()
   (define-key elscreen-map (kbd "SPC") 'elscreen-next)
   ))
