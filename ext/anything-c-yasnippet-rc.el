(rc-ext
 :name 'anything-c-yasnippet
 :get
 (lambda ()
   (browse-url (concat "http://svn.coderepos.org/share/lang/elisp/"
                       "anything-c-yasnippet/anything-c-yasnippet.el"))
   (browser-url "http://d.hatena.ne.jp/shiba_yu36/20100615/1276612642"))
 :requires '(yasnippet anything)
 :autoload '(
             my-anything-c-yas-complete
             anything-c-yas-complete
             anything-c-yas-visit-snippet-file
             anything-c-yas-create-snippet-on-region
             )
 :init
 (lambda ()

   (defun my-anything-c-yas-complete ()
     (interactive)
     (anything :sources
               '(anything-c-source-yasnippet
                 anything-c-source-yasnippet-snippet-files)))
   )
 )

