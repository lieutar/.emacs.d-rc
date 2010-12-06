(rc-ext
 :class 'edit-yapp

 :name  'yapp-yacc-mmm

 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.yp\\'" . yacc-mode)))

 :init
 (lambda ()
   (require 'mmm)
   (mmm-add-classes
    '((yacc-perl
       :submode cperl-mode
       :face mmm-declaration-submode-face
       :front "^%{\n"
       :back  "\n%}"
       )))
   (mmm-add-mode-ext-class nil "\\.yp\\'" 'yacc-perl)
   )
)