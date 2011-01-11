
(rc-ext
 :name 'auto-install
 :load  'auto-install
 :get  "http://www.emacswiki.org/emacs/download/auto-install.el"
 :autoload 'auto-install-batch
 :preload
 (lambda ()
   (setq auto-install-directory
         (expand-file-name (concat "~/.emacs.d/auto-install."
                                   rc-emacsen
                                   "/")))
   (unless (file-exists-p auto-install-directory)
     (make-directory auto-install-directory))
   (add-to-list 'load-path auto-install-directory)
   )
 :init
 (lambda ()
   ))
