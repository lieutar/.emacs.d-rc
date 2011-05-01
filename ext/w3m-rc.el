(defvar my-rc-browse-url-default-browser-function
     browse-url-browser-function)

(rc-ext
 :name 'w3m
 :load 'w3m
 :autoload '(w3m
             w3m-browse-url)
 :required '(apel)
 :get (lambda () (funcall
                  my-rc-browse-url-default-browser-function
                  "http://emacs-w3m.namazu.org/"))
 :preload
 (lambda ()


   (setq browse-url-browser-function 
         `((,(concat
              "^" (regexp-opt
                   '("http://www.google.com/reader/"
                     "http://maps.google.co.jp/"
                     "http://map.yahoo.co.jp/"
                     "http://map.labs.goo.ne.jp/"
                     "http://www.haloscan.com/"
                     "http://sitemeter.com/"
                     "http://www.hmv.co.jp/"
                     "http://h.hatena.ne.jp/"
                     "http://h1beta.hatena.ne.jp/"
                     "http://twitter.com/"
                     )))
            . my-rc-browse-url-default-browser-function)
           ("." . w3m-browse-url)))
   )
 :on-load-error
 (lambda ()
   (setq browse-url-browser-function my-rc-browse-url-default-browser-function)))

