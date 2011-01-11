"


"
;; dired
(require 'dired)
(rc-load "rc-vise-km")
(rc-vise-km dired-mode-map)

;; wdired
(rc-ext
 :load 'wdired
 :get  "http://www.emacswiki.org/elisp/wdired.el"
 :autoload 'wdired-change-to-wdired-mode
 :preload
 (lambda ()
   (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
   )

 :init
 (lambda ()


   ))

