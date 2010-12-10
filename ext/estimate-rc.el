(rc-ext
 :name 'estimate
 :autoload '(estimate-mode)

 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.estimate\\'" . estimate-mode))
   )

 :init
 (lambda ()
   (setq estimate-source-json "~/.estimate.json")))

