 (rc-ext
 :load (lambda ()
         (load-library "rng-auto")
         (require 'nxml-mode))

 :get
 (lambda ()
   (browse-url "http://www.thaiopensource.com/nxml-mode/"))

 :preload
 (lambda ()
   (setq auto-mode-alist
         (cons `(,(concat "\\.\\("
                          (mapconcat
                           (lambda (a)a)
                           '(
                             "xml"
                             "xslt?"
                             "rng"
                             "xhtml"
                             "svg"
                             "x3d"
                             )
                           "\\|"
                           )
                          "\\)\\'") . nxml-mode)
               auto-mode-alist))
   )

 :autoload 'nxml-mode

 :init
 (lambda ()
   (setq nxml-child-indent 2)
   (push "c:/cygwin/usr/local/share/fo-schemas/schemas.xml"
         rng-schema-locating-files-default
         )
   ))
