(rc-ext
 :load 'thumbs
 :get "http://repo.or.cz/w/emacs.git/blob_plain/HEAD:/lisp/thumbs.el"
 :init
 (lambda ()
   
   (let ((tkm (lookup-key dired-mode-map (kbd "C-t") nil)))
     (define-key dired-mode-map (kbd "C-t") nil)
     (define-key dired-mode-map (kbd "M-t") tkm))
   )
)


