(rc-ext
 :name 'apache-mode
 :autoload 'apache-mode
 :get "http://www.emacswiki.org/cgi-bin/wiki/download/apache-mode.el"
 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.htaccess\\'"   . apache-mode))
   (add-to-list 'auto-mode-alist '("httpd\\.conf\\'"  . apache-mode))
   (add-to-list 'auto-mode-alist '("srm\\.conf\\'"    . apache-mode))
   (add-to-list 'auto-mode-alist '("access\\.conf\\'" . apache-mode))
   (add-to-list 'auto-mode-alist '("sites-\\(available\\|enabled\\)/" .
                                   apache-mode))
   ))
