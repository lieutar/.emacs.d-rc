(rc-ext
 :load 'cygwin-mount
 :cond (lambda () (eq system-type 'windows-nt))
 :get  "http://www.emacswiki.org/cgi-bin/wiki/download/cygwin-mount.el"
 :init
 (lambda ()
   (cygwin-mount-activate)
   ))


