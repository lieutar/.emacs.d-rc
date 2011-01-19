(rc-ext
 :name     'gtags
 :get (lambda ()
        (message 
         "prease copy the `gtags.el' file from GNU Global source archive."))
 :autoload '(gtags-find-tag
             gtags-find-rtag
             gtags-find-symbol
             gtags-find-pattern
             gtags-find-file
             gtags-pop-stack)
 :init
 (lambda ()
   ))

