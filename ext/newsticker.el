(rc-ext
 :load 'news-ticker
;; :get (lambda () (browse-url "http://www.nongnu.org/newsticker/"))
 :autoload '(news-ticker-show-news
             news-ticker-start
             news-ticker-start-ticker)
 :init
 (lambda ()
   ))

