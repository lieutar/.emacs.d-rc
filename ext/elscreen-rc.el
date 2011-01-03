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
   (rc-load "myenv-elscreen")
   ))

