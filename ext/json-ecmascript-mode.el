(rc-ext
 :class    'edit-json
 :name     'json-ecmascript-mode
 :load     'ecmascript-mode
 :get      "http://www.emacswiki.org/emacs/download/ecmascript-mode.el"
 :autoload 'ecmascript-mode
 :preload  (lambda ()
             (add-to-list 'auto-mode-alist
                          '("\\.json\\'" . ecmascript-mode)))
)
