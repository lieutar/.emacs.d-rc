(rc-ext
 :name    'accounting
 :get      "http://www.moge.org/okabe/temp/accounting.el"
 :autoload '(accounting-region)
 :init 
 (lambda ()
   (setq account-doll-in-cent "1.0")
   )
 )
