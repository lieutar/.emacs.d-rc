(rc-ext
 :name  'anything
 :load  (lambda () (load-library "anything-config"))
 :get   (lambda () (auto-install-batch "anything"))
 :init
 (lambda ()

   (global-unset-key (kbd "C-x C-f"))
   (global-set-key (kbd "C-x C-f") 'find-file)

   (global-set-key (kbd "M-x") 'anything-M-x)


   )
 )


(rc-ext
 :requires '(anything
             find-git)
 :autoload 'my-anything-open
 :init
 (lambda ()

   (defun my-anything-open ()
     (interactive)
     (anything
      :sources
      (append
       `(
         anything-c-source-buffers
         anything-c-source-bookmarks
         anything-c-source-recentf

         ,@find-git-anything-c-sources

         anything-c-source-file-cache
         anything-c-source-files-in-current-dir
         anything-c-source-locate
         )
       (when current-prefix-arg
         '(
           anything-c-source-elisp-library-scan
           ))
       )
      :buffer "*open-files*"))
   ))
