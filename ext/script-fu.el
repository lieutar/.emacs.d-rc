(rc-ext
 :autoload '(script-fu-mode
             script-fu-other-window)
 :load
 (lambda ()
   (load "c:/cygwin/home/lieutar/work/script-fu-shell/script-fu.el"))
 :init
 (lambda ()
   (setq script-fu:use-eldoc t)
   (setq script-fu:use-anything t)
   (setq script-fu:use-auto-complete t)
   (setq script-fu-program-name
         "c:/cygwin/home/lieutar/work/script-fu-shell/script-fu-shell.rb"))
 )
