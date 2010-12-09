(rc-ext
 :cond (lambda () nil)
 :path "auto-complete"
 :name 'auto-complete
 :get  (lambda ()
         (browse-url "https://github.com/m2ym/auto-complete")
         )
 :load 'auto-complete-config
 :init
 (lambda ()
   (add-to-list 'ac-dictionary-directories
                "c:/cygwin/usr/local/share/auto-complete/ac-dict")
   (ac-config-default)
   )
)

