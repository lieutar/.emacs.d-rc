(rc-ext
 :name  'anything
 :requires '(auto-install)
 :load  (lambda () (load-library "anything-config"))
 :get   (lambda () (auto-install-batch "anything"))
 :init
 (lambda ()

   (global-unset-key (kbd "C-x C-f"))
   (global-set-key   (kbd "C-x C-f") 'find-file)
   (global-set-key   (kbd "M-x")     'anything-M-x)
   (global-set-key   (kbd "C-x b")   'anything-buffers+)

   )
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(rc-ext
 :name     'my-anything-open
 :load      nil
 :requires '(
             anything
             find-git
             )
 :autoload 'my-anything-open
 :init
 (lambda ()


   (when nil

   (defconst anything-c-elisp-library-scan2:libs nil)
   (defconst anything-c-source-elisp-library-scan2
     (copy-alist anything-c-source-elisp-library-scan))

   (setcdr (assq 'init anything-c-source-elisp-library-scan2)
           'anything-c-elisp-library-scan2-init)

   (defun anything-c-elisp-library-scan2-init
     (when anything-c-elisp-library-scan2:libs
       (insert anything-c-elisp-library-scan2:libs)))

   (defadvice anything-c-elisp-library-scan-init (around
                                                  my-rc
                                                  activate)
     (with-temp-buffer
       (let ((anything-buffer (current-buffer)))
         ad-do-it
         (setq anything-c-elisp-library-scan2:libs
               (buffer-substring (point-min) (point-max)))))
     (with-current-buffer anything-buffer
       (insert anything-c-elisp-library-scan2:libs)))

   (ad-deactivate  'anything-c-elisp-library-scan-init)

   )


   (defun my-anything-open ()
     (interactive)
     (anything
      :sources
      (append
       `(
         anything-c-source-bookmarks
         anything-c-source-recentf

         ,@find-git-anything-c-sources

         anything-c-source-file-cache
         anything-c-source-files-in-current-dir
         anything-c-source-locate
         )
       (if current-prefix-arg
         '(
           anything-c-source-elisp-library-scan
           ))
       )
      :buffer "*open-files*"))
   ))
