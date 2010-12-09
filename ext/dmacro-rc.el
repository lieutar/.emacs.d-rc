(rc-ext
 :load (lambda () (load-library "dmacro"))
 :get "http://www.pitecan.com/papers/JSSSTDmacro/dmacro.el"
 :autoload 'dmacro-exec
 :preload
 (lambda ()
   (defconst *dmacro-key* [?\C-\S-r])
   (global-set-key *dmacro-key* 'dmacro-exec)
   )
 :init
 (lambda ()

   ))
