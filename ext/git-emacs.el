(rc-ext
 :class 'git
 :name  'git-emacs
 :load 
 (lambda ()
 
   (and
    (rc-ext
     :get
     (lambda ()
       (message "Prease check /usr/share/doc/git-core/contrib/emacs."))
     :load
     (lambda ()
       (require 'git)
       (require 'vc-git)
       (require 'git-blame)))

    (rc-ext
     :name 'vc-git
     :get "http://braeburn.aquamacs.org/code/master/lisp/vc-git.el")

    (rc-ext
     :name 'vc-dir
     :get  "http://braeburn.aquamacs.org/code/master/lisp/vc-dir.el")

    (rc-ext
     :path "git-emacs"
     :load 'git-emacs
     :get  (lambda ()
             (let ((default-directory (concat rc-site-lisp "/")))
               (message "git-emacs:cloning git repositry ...")
               (shell-command
                "git clone git://github.com/tsgates/git-emacs.git"))
            )
     :load
     (lambda () 
       (load "git-emacs")
       (load "git-log")
       )
     :init 
     (lambda ()
       ))
    )
   ))
 