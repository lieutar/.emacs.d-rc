(rc-ext
 :name 'find-git
 :autoload 'find-git
 :init
 (lambda ()
   (setq

    find-git-exclude-patterns-list
    '(
      "~/\.\.*"
      "/rc/site-lisp\\."
      "/\\.mozilla"
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
      )

    find-git-include-pathes-list
    '(
      "~/.emacs.d"
      )

    find-git-nested-tree-list
    '(
      "~"
      )
    
    )
   ))

