(rc-ext
 :name  'framov
 :get   "https://github.com/lieutar/framov.el/raw/master/framov.el"
 :autoload '(global-framov-mode)
 :init
 (lambda ()
   (setq framov-x-screen-margin '(-8 0 48 -8))))

