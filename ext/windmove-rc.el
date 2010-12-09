(rc-ext
 :load 'windmove
 :get  (lambda () (browse-url "http://www.emacswiki.org/emacs/WindMove"))
 :init
 (lambda ()
   (windmove-default-keybindings)
   (setq windmove-wrap-around nil)
   )
 )
