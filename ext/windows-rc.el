(rc-ext
 :name 'windows
 :class 'window-manager
 :load
 (lambda () (load-library "windows"))
 :preload
 (setq win:configuration-file
       (expand-file-name (concat "~/.emacs.d/.windows."
                                 rc-emacsen)))
 :get
 (lambda ()
   (rc-get "http://www.gentei.org/~yuuji/software/revive.el")
   (rc-get "http://www.gentei.org/~yuuji/software/windows.el"))
 :init
 (lambda ()
   ;; 新規にフレームを作らない
   (setq win:use-frame nil)
   (define-key ctl-x-map "C" 'see-you-again)
   (win:startup-with-window)
   )
 )

