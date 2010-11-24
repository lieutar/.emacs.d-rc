(rc-ext
 :load 'skk
 :autoload '(skk-mode)
 :get 
 (lambda ()
   (browse-url "http://openlab.ring.gr.jp/skk/maintrunk/"))
 :preload
 (lambda ()
   (global-set-key [?\C-x ?\C-j] (function skk-mode))
   ))
