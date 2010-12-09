(rc-ext
 :autoload 'yaml-mode
 :load 'yaml-mode
 :get  "http://github.com/yoshiki/yaml-mode/raw/master/yaml-mode.el"
 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.ya?ml\\'" . yaml-mode))))

