(rc-ext
 :load 'gnuserv
 :get (lambda ()
        (browser-url "http://shimooku.hp.infoseek.co.jp/gnuserv.html"))
 :init
 (lambda ()
   (gnuserv-start)))
