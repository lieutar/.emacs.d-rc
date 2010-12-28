(rc-ext
 :name 'estimate
 :load 'estimate-mode
 :autoload '(estimate-mode)

 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.estimate\\'" . estimate-mode))
   )

 :init
 (lambda ()
   (setq estimate-source-jsons '("~/work/job/core/estimate/items.json"))))

