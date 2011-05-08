(rc-ext
 :load 'rc-menu
 :init
 (lambda ()

   (defvar my-working-environment-hook nil)

   (defun setup-my-working-environment:confirm ()
     (rc-menu:confirm
      :timeout 5
      :default-action 
      (lambda ()
        (run-hooks 'my-working-environment-hook))))
   
   (add-hook 'after-init-hook 'setup-my-working-environment:confirm)

   ))
