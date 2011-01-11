(rc-ext
 :load 'rc-menu
 :init
 (lambda ()

   (defun setup-my-working-environment:confirm ()
     (rc-menu:confirm
      :timeout 5
      :default-action 
      (lambda ()
        (let ((width (cdr (assq 'width (frame-parameters nil)))))
          (cond 
           ((>= width 250)
            (my-rc-3cols-environment))
           ((>= width 164)
            (my-rc-wide-screen-environment))
           (t
            (my-rc-narrow-screen-environment)))))))

   (add-hook 'after-init-hook 'setup-my-working-environment:confirm)

   ))
