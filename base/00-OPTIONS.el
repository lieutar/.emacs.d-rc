(set-language-environment     'Japanese)
(set-default-coding-systems   'utf-8-unix)
(setq-default make-backup-files nil)
(setq-default indent-tabs-mode nil)
(setq inhibit-startup-message t) 
(setq scroll-step 1)

(setq load-path

      (append

       (apply
        'append
        (mapcar
         (lambda (work)
           (when (file-readable-p work)
             (apply 'append
                    (list work)
                    (mapcar
                     (lambda (file)
                       (unless (string-match "^\\.+$" file)
                         (let ((full (expand-file-name (concat work "/" file))))
                           (when (file-directory-p full)
                             (list full)))))
                     (directory-files work)))))
         (list
          (expand-file-name "~/share/emacs/site-lisp")
          (expand-file-name "~/work/emacs")
          )))

       load-path))



