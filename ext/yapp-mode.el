(rc-ext
 :class 'edit-yapp
 :name  'yapp-mode
 :get (lambda ()
	(browse-url
	"http://www.kmc.gr.jp/~tak/sources/el/yapp-mode.el.gz"))
 :autoload 'yapp-mode
 :preload (lambda ()
            (add-to-list 'auto-mode-alist '("\\.yp\\'" . yapp-mode))))
