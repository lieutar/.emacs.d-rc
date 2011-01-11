(rc-ext
 :name 'graphviz-dot-mode
 :load (lambda () (load "graphviz-dot-mode"))
 :get "http://www.graphviz.org/Misc/graphviz-dot-mode.el"
 :preload (lambda ()
            (add-to-list 'auto-mode-alist '("\\.dot\\'" . graphviz-dot-mode)))
 :autoload '(graphviz-dot-mode)
 :init
 (lambda ()
   (setq graphviz-dot-indent-width 2)
   (setq graphviz-dot-preview-extension "svg")
   (defadvice graphviz-dot-preview (around my-rc first () activate)
     (if (equal graphviz-dot-preview-extension "svg")
         (cygstart (concat (file-name-sans-extension buffer-file-name)
                           ".svg"))
       ad-do-it)
     )
   )
)

