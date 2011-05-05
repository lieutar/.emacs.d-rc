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

   (add-hook
    'my-working-environment-hook
    (lambda ()
      (elswm-frame:set-environment-name
       (let ((width (frame-parameter nil 'width)))
         (cond 
          ((>= width 250) '3cols)
          ((>= width 200) '2.5cols)
          ((>= width 164) 'wide)
          (t              'narrow))))
      (elswm-mode 1)))
    
   (defadvice w3m-browse-url (around my-elswm-rc-ad first activate)
     (save-window-excursion ad-do-it)
     (pop-to-buffer "*w3m*"))

   (add-to-list 'elswm-ad:select-window-functions
                'w3m-browse-url)

   ))
