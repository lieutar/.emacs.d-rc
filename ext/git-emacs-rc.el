(rc-ext
 :class 'git
 :name  'git-emacs
 :load 
 (lambda ()
 
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
    :autoload
    '(
      gitk
      git-add
      git-add-interactively              git-add-new
      git-after-working-dir-change       git-baseline
      git-blame-mode                     git-branch
      git-checkout                       git-checkout-to-new-branch
      git-clone                          git-cmd
      git-commit                         git-commit-all
      git-commit-file                    git-config-init
      git-create-branch                  git-delete-branch
      git-delete-tag                     git-diff-all-baseline
      git-diff-all-head                  git-diff-all-index
      git-diff-all-other                 git-diff-baseline
      git-diff-head                      git-diff-index
      git-diff-other                     git-grep
      git-history                        git-ignore
      git-init                           git-init-from-archive
      git-log                            git-log-files
      git-log-other                      git-merge
      git-merge-next-action              git-pull-ff-only
      git-reset                          git-resolve-merge
      git-revert                         git-snapshot
      git-stash                          git-switch-branch
      git-tag
      )
    :init 
    (lambda ()
      ))
   ))
