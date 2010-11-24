(rc-ext
 :load 'php-mode
 :autoload 'php-mode
 :preload (lambda ()
            (setq auto-mode-alist
                  (cons (cons "\\.php\\'" 'php-mode)
                        auto-mode-alist)))
 :get  (lambda ()
         (browse-url "http://sourceforge.net/projects/php-mode/")))
