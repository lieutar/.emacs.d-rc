(rc-ext
 :load 'ruby-mode
 :get  (lambda () (package-install 'ruby-mode))
 :autoload 'ruby-mode
 :preload (lambda ()
            (setq auto-mode-alist
                  (cons (cons "\\.rb\\'" 'ruby-mode)
                        auto-mode-alist)))
 :init (lambda ()
         ))
