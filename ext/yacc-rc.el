(rc-ext
 :name 'yacc
 :get "http://www.rubyist.net/~matz/a/yacc.el"
 :autoload '(yacc-mode)
 :preload (lambda ()
            (add-to-list 'auto-mode-alist '("\\.y\\'" . yacc-mode)))
)
