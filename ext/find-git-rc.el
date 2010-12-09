(rc-ext
 :name 'find-git
 :autoload 'find-git
 :get "https://github.com/lieutar/find-git.el/raw/master/find-git.el"
 :init
 (lambda ()
   (setq

    find-git-auto-status-mode t

    find-git-exclude-patterns-list
    '(
     "/\\.[^/]+\\'"
      "/rc/site-lisp\\."
      "/\\.emacs\\.d/elpa"
      )

    find-git-exclude-pathes-list
    '(
      "~/smb"
      "~/sandbox"
      "~/Desktop"
      "~/work/build"
      "~/work/pending"
      "~/work/codereading"
      "~/share/emacs"
      "~/local"
      "~/public_html"
      )

    find-git-include-pathes-list
    '(
      "~/.emacs.d"
      )

    find-git-nested-tree-list
    '(
      "~"
      "~/.emacs.d"
      )
    
    )
   ))

