(rc-ext
 :name 'sr-speedbar
 :get "http://www.emacswiki.org/emacs/download/sr-speedbar.el"
 :autoload
 '(sr-speedbar-toggle
   sr-speedbar-open)
 :preload
 (lambda ()
   )
 :init
 (lambda ()
   (setq sr-speedbar-width-x 37)
   (setq sr-speedbar-right-side nil)
   (setq sr-speedbar-skip-other-window-p t)
   (setq sr-speedbar-buffer-name " SPEEDBAR")

   )
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

