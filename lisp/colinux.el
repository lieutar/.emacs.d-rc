(rc-ext
 :name 'cygstartsrv
 :load-path 'cygstartsrv
 :cond 
 (lambda ()
   (or 
    (equal "comisuzu" system-name)
    (equal "cotreefrog" system-name)))
 :init
 (lambda () 
   (if (equal "comisuzu" system-name)
       (progn
         (setq cygstartsrv/server-name "192.168.1.128"))
     (progn
       ()))
   (setq browse-url-browser-function  'cygstartsrv/browse-url)
   ))
