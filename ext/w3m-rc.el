(rc-ext
 :name 'w3m
 :load 'w3m
 :autoload 'w3m
 :required '(apel)
 :get (lambda () (browse-url "http://emacs-w3m.namazu.org/"))
 :init (lambda ()))

