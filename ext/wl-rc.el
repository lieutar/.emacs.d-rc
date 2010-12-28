(rc-ext
 :autoload 'wl
 :load (lambda ()
         (require 'wl)
         (require 'starttls)
         (require 'ssl))

 :get  (lambda ()
         (browse-url "http://www.gohome.org/wl/index.ja.html"))

 :init
 (lambda ()
   (autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)
   (setq ssl-certificate-verification-policy 1) 
   (setq ssl-program-name "openssl")
   (setq starttls-negotiation-by-kill-program t)
   (rc-emacsen-case
    (@-nt-@
     (setq starttls-kill-program "c:/cygwin/bin/kill")))


   ))
