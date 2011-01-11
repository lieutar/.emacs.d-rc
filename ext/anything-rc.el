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
   ;;(global-set-key   (kbd "C-x b")   'switch-to-buffer)

   (defvar anything-c-source-info-elisp
     '((name . "Info index: elisp")
       (info-index . "elisp")))

   (defun anything-elisp-info ()
     (interactive)
     (anything 'anything-c-source-info-elisp))
   (define-key emacs-lisp-mode-map
     (kbd "C-c C-a i") 'anything-elisp-info)

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



   (defconst my-anything-rc-dirs '("lisp"
                                   "ext"
                                   "funcs"
                                   "last"))

   (defconst anything-c-source-rc-dirs
     '((name . "RC directories")
       (candidates
        . (lambda ()
            (append
             (mapcar (lambda (dir)
                       (expand-file-name dir rc-directory))
                     my-anything-rc-dirs))))
       (action
        . (("Dired" . dired)
           ("New"   . (lambda (dir)
                        (let ((default-directory dir))
                          (call-interactively 'find-file))))))))

   (defconst anything-c-source-rc-files
     '((name . "RC files")
       (candidates
        . (lambda ()
            (apply
             'append
             (mapcar 
              (lambda (dir)
                (apply 'append
                       (mapcar 
                        (lambda (file)
                          (when (string-match "\\.el\\'" file)
                            (list
                             (cons
                              (format "rc/%s/%s" dir file)
                              (expand-file-name
                               file
                               (expand-file-name dir rc-directory))))))
                        (directory-files
                         (expand-file-name dir rc-directory)))))
              (append
               (let ((farmdir (expand-file-name "farm"  rc-directory)))
                 (apply 'append
                        (mapcar
                         (lambda (dir)
                           (let ((full (expand-file-name dir farmdir)))
                             (when (and (string-match "[^.]" dir)
                                        (file-directory-p full))
                               (list (format "farm/%s" dir)))))
                         (directory-files farmdir))))
               my-anything-rc-dirs)))
            ))
       (type . file)))

   (defun my-anything-open ()
     (interactive)
     (anything
      :sources
      (append
       `(
         anything-c-source-bookmarks
         anything-c-source-recentf

         ,@find-git-anything-c-sources
         anything-c-source-rc-dirs
         anything-c-source-rc-files

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
