(rc-ext
 :name  'e2wm
 :class 'window-manager
 :get
 (lambda ()
   (rc-get (concat "http://github.com/kiwanami/emacs-window-layout/raw/"
                   "master/window-layout.el"))
   (rc-get (concat "http://github.com/kiwanami/emacs-window-manager/raw/"
                   "master/e2wm.el")))
 :init
 (lambda ()
   (e2wm:start-management)
   ))
