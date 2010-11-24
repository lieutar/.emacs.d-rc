(set-language-environment     'Japanese)
(set-default-coding-systems   'utf-8-unix)
(setq-default make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t) 

(setq load-path

      (append
       (list
        (expand-file-name "~/share/emacs/site-lisp")
        )

       (let ((work (expand-file-name "~/work/emacs")))
         (when (file-readable-p work)
           (apply 'append
                  (mapcar
                   (lambda (file)
                     (unless (string-match "^\\.+$" file)
                       (let ((full (expand-file-name (concat work "/" file))))
                         (when (file-directory-p full)
                           (list full)))))
                   (directory-files work)))))

       load-path))



  
(setq scroll-step 1)
