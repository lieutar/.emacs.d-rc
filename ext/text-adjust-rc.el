(rc-ext
 :name 'text-adjust
 :get
 (lambda ()
   (rc-get "http://taiyaki.org/elisp/mell/src/mell.el")
   (rc-get "http://taiyaki.org/elisp/text-adjust/src/text-adjust.el"))
 :autoload  (apply 'append
                   (mapcar (lambda (src)
                             (list src
                                   (intern (format "%s-region" src))
                                   (intern (format "%s-buffer" src))))
                           '(text-adjust-codecheck
                             text-adjust-hankaku
                             text-adjust-kutouten
                             text-adjust-space
                             text-adjust
                             text-adjust-fill
                             )))
 :init
 (lambda ()
   ))