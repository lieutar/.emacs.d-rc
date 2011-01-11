(rc-ext
 :path "ejacs"
 :name 'ejacs
 :load 'js-console
 :get (lambda ()
        (message 
          "
wget http://ejacs.googlecode.com/files/ejacs-11-16-08.zip
mkdir ejacs
cd ejacs
unzip ../ejacs-11-16-08.zip
cd ..
mv ejacs %s

"
          rc-site-lisp)
        (browse-url
         "http://code.google.com/p/ejacs/")
        )
 :autoload '(js-console)
 )