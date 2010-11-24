(rc-ext
 :autoload '(script-fu-mode
             script-fu-other-window)
 :get
 (lambda () (browse-url "https://github.com/sonota/script-fu-shell"))
 :load 'script-fu
 :init
 (lambda ()
   (setq script-fu:use-eldoc t)
   (setq script-fu:use-anything t)
   (setq script-fu:use-auto-complete t)
   (setq script-fu-program-name
         (concat (replace-regexp-in-string
                  "[^\\\\/]+$"
                  ""
                  (locate-library "script-fu")
                  )
                 "script-fu-shell.rb")))
 )

