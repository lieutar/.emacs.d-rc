(rc-ext
 :class 'git
 :name  'git
 :get
 (lambda ()
   (message "Prease check /usr/share/doc/git-core/contrib/emacs."))

 :load
 (lambda ()
   (require 'git)
   (require 'vc-git)
   (require 'git-blame)
   )
 )


