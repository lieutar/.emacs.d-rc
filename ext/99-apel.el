(rc-ext
 :load
 (lambda ()
   (require 'poe)
   )
 :get
 (lambda ()
   (browse-url "http://cvs.m17n.org/elisp/APEL/")
   )
 :init
 (lambda ()
   ))
