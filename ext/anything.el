(rc-ext
 :load  (lambda () (load-library "anything-config"))
;; :get   (lambda () (auto-install-batch "anything"))
 :init
 (lambda ()

   (defvar anything-command-list nil)
   (defmacro defanything (name sources)
     (let* ((cmd-name  (concat "anything-" name))
            (cmd       (intern cmd-name))
            (star-cmd  (concat "*" cmd-name "*")))
     `(progn
        (add-to-list 'anything-command-list ,cmd-name)
        (defun ,cmd ()
          (interactive)
          (anything
           ',(map 
              'list
              (lambda (x) (intern (concat "anything-c-source-" x)))
              sources)
           nil
           nil
           nil
           nil 
           ,star-cmd
           )))))

   (defanything
       "open-files"
       (
        "recentf"
        "file-cache"
        "files-in-current-dir"
        "locate"
        ))

   (defanything "emacs-variables"
     ("emacs-variables"))

   (defanything "emacs-functions"
     ("emacs-functions"))

   (global-unset-key (kbd "C-x C-f"))
   (global-set-key (kbd "C-x C-f") 'find-file)
   )
 )

