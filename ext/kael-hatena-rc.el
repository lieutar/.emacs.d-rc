(rc-ext
 :name 'kael-hatena
 :autoload
 '(
   kael-hatena-login
   kael-hatena-haiku-region
   kael-hatena-haiku-update
   )
 :init
 (lambda ()
   (setq kael-hatena-user-alist
         (acman-get-property-alist "hatena.ne.jp" "password"))
   ))
