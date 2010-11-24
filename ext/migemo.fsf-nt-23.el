(rc-ext
 :load 'migemo
 :get (lambda ()
        (browse-url "http://0xcc.net/ruby-bsearch/")
        (browse-url "http://0xcc.net/migemo/")
        (browse-url "http://0xcc.net/ruby-romkan/")
        )
 :init (lambda ()
         (setq migemo-use-pattern-alist t)
         (setq migemo-use-frequent-pattern-alist t)
         ))

