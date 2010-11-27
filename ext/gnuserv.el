(rc-ext
 :load
 (if (rc-emacsen-match "fsf-unicom-@") 'gnuserv-compat 'gnuserv)
 :get
 (lambda () (browser-url "http://shimooku.hp.infoseek.co.jp/gnuserv.html"))
 :init
 (lambda () (gnuserv-start))
)
