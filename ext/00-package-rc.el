(rc-ext
 :autoload 'package-install

 :load 
 (lambda ()
   (load (format "%s/package.el" package-user-dir)))

 :preload
 (lambda ()
   (setq package-user-dir
         (expand-file-name (format "~/.emacs.d/elpa.%s"
                                   rc-emacsen)))
   (unless (file-exists-p package-user-dir)
     (make-directory package-user-dir)))


 :get
 (lambda ()
   (let ((buffer (url-retrieve-synchronously
                  "http://tromey.com/elpa/package-install.el")))
     (save-excursion
       (set-buffer buffer)
       (goto-char (point-min))
       (re-search-forward "^$" nil 'move)
       (eval-region (point) (point-max))
       (kill-buffer (current-buffer))))
   (package-install 'package)
   (require 'package)
   )

 :init
 (lambda ()
   (setq package-archives
         '(("ELPA" . "http://tromey.com/elpa/") 
           ("gnu" . "http://elpa.gnu.org/packages/")))
  
   (package-initialize)

   ))

