(rc-ext
 :class 'git
 :name  'magit
 :load  'magit
 :get   (lambda () (browse-url "https://github.com/magit/magit/downloads"))
 :autoload '(magit-status
             magit-init)
 :preload (lambda ()
            (defalias 'my-git-status 'magit-status))
 )

;;(magit-status)

