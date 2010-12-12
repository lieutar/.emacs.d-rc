(rc-ext
 :load  (lambda () (load-library "anything-config"))
 :get   (lambda () (auto-install-batch "anything"))
 :init
 (lambda ()

   (defun anything-open-files ()
     (interactive)
     (anything
      :sources '(
                anything-c-source-bookmarks
                anything-c-source-find-git
                anything-c-source-recentf
                anything-c-source-elisp-library-scan
                anything-c-source-file-cache
                anything-c-source-files-in-current-dir
                anything-c-source-locate
                )
      :buffer "*open-files*"))

   (global-unset-key (kbd "C-x C-f"))
   (global-set-key (kbd "C-x C-f") 'find-file)
   )
 )

