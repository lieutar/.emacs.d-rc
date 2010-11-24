(rc-ext
 :load 'mmm-mode
 :get (lambda ()
        (browse-url "http://sourceforge.net/projects/mmm-mode/files/"))
 :init
 (lambda ()

   (setq mmm-mode-ext-classes-alist nil)


   (setq mmm-global-mode 'maybe)


   (mmm-add-classes
    '(
      (embedded-css
       :submode css-mode
       :face mmm-declaration-submode-face
       :front "<style[^>]*>\\([\\s \n\r]*<!--[\\s \n\r]*\\)?"
       :back "\\([\\s \n\r]*-->[\\s \n\r]*\\)?</style>"
       ;;:front "<style[^>]*>"
       ;;:back "</style>"
       )

      (embedded-js
       :submode js2-mode
       :face    mmm-code-submode-face
       :front "<script[^>]*>\\([\\s \n\r]*<!--[\\s \n\r]*\\)?"
       :back "\\([\\s \n\r]*-->[\\s \n\r]*\\)?</script>"
       ;;:front "<script[^>]*>"
       ;;:back "</script>"
       )

      (embedded-js4xl
       :submode js2-mode
       :face    mmm-code-submode-face
       :front "<javascript>"
       :back "</javascript>"
       )
      ))


   (mapcar
    (lambda (ext)
      (mmm-add-mode-ext-class nil ext 'embedded-css)
      (mmm-add-mode-ext-class nil ext 'embedded-js)
      )
    '(
      "\\.html?\\'"
      "\\.xhtml?\\'"
      ))



   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   (defun my-rc-enter-mmm-mode ()
     (mmm-mode t))

   (mapcar
    (lambda (hook)
      (add-hook hook 'my-rc-enter-mmm-mode))
    '(
      html-mode-hook
      ))

   ))
