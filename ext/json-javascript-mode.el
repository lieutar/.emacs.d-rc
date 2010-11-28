(rc-ext
 :class    'edit-json
 :name     'json-javascript-mode
 :load     (lambda () (load-library "javascript"))
 :get      "http://www.brgeight.se/downloads/emacs/javascript.el"
 :autoload 'javascript-mode
 :preload  (lambda ()
             (add-to-list 'auto-mode-alist
                          '("\\.json\\'" . javascript-mode)))
)
