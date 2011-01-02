(rc-ext
 :load 'rc-menu
 :init
 (lambda ()

   (defun setup-my-working-environment:confirm ()
     (rc-menu:confirm
      :timeout 5
      :default-action 
      (lambda ()
        (if (> (x-display-pixel-width) 800)
            (progn
              (modify-frame-parameters (selected-frame) '((width  . 166)))
              (my-rc-wide-screen-envronment))
          (progn
            (my-rc-narrow-screen-environment))))))

   (add-hook 'after-init-hook 'setup-my-working-environment:confirm)))
