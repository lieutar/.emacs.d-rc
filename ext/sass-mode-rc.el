(rc-ext
 :load 'sass-mode
 :get  "https://github.com/mislav/haml/raw/master/extra/sass-mode.el"
 :autoload 'sass-mode
 :preload (lambda ()
            (setq auto-mode-alist
                  (cons (cons "\\.sass\\'" 'sass-mode)
                         auto-mode-alist)))
 :init (lambda ()
         ))