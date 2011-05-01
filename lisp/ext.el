(setq
 rc-ext-classes-alist
 '(
   (window-manager . elscreen)
   ;;(window-manager . e2wm)

   (emacs-server . server)
   ;;(emacs-server . gnuserv)

   (git . magit)

   ;;(edit-json . json-ecmascript-mode)
   (edit-json . json-javascript-mode)
   ;;
   ;;(edit-yapp . yapp-yacc-mmm)
   (edit-yapp . yapp-mode)
   )
 )
(rc-load-directory "ext")
