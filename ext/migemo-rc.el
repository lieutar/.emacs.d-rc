(rc-ext
 :load 'migemo
 :get (lambda ()
        (browse-url "http://0xcc.net/ruby-bsearch/")
        (browse-url "http://0xcc.net/migemo/")
        (browse-url "http://0xcc.net/ruby-romkan/")
        )
 :init
 (lambda ()
   (setq migemo-use-pattern-alist t)
   (setq migemo-use-frequent-pattern-alist t)
   (setq migemo-user-dictionary
         "c:/cygwin/home/lieutar/.migemo-user-dict")
   (when (migemo-toggle-isearch-enable)
     (migemo-toggle-isearch-enable))
   ))

