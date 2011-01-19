(rc-ext
 :name  'elswm
 :requires '(elscreen)
 :load (lambda ()
         (require 'elswm)
         (require 'elswm-farm-commands))
 :init
 (lambda ()
   (setq elswm-directory "~/.emacs.d/rc/elswm")
   (define-key elscreen-map (kbd "C-c") 'elswm:create)
   (global-set-key (kbd "C-x 5 2") 'elswm:temporary-frame:open)
   
   (dolist (conf '((3cols         3cols)
                   (wide-screen   wide)
                   (narrow-screen narrow)))
     (let ((fun  (intern (format "my-rc-%s-environment" (car conf))))
           (envn (cadr conf)))
       (eval
        `(defun ,fun ()
           (elswm-frame:set-environment-name ',envn)
           (elswm-mode t)))))
   ))
