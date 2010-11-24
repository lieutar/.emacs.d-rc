(rc-ext
 :class 'git
 :name  'magit
 :load  'magit
 :get   (lambda () (browse-url "http://philjackson.github.com/magit/"))
 :autoload '(magit-status
             magit-init)
 )

