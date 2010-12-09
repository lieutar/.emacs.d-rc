(rc-ext
 :cond (lambda ())
 :load (rc-emacsen-case
        (meadow-@-@ 'gnuserv)
        (t          'gnuserv-compat))
 :get
 (lambda ()
   (browse-url
    (rc-emacsen-case
     (@-nt-@
      "http://www.wyrdrune.com/index.html?gnuserv.html")
     (t
      "http://www.hpl.hp.com/personal/ange/gnuserv/home.html"))))
 :init
 (lambda () (gnuserv-start))
)
