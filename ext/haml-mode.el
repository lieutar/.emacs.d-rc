(rc-ext
 :name 'haml-mode
 :preload
 (lambda ()
   (setq auto-mode-alist
         (cons (cons "\\.haml\\'" 'haml-mode)
               auto-mode-alist)))
 :get  "https://github.com/mislav/haml/raw/master/extra/haml-mode.el"
 :init (lambda ()
         ))