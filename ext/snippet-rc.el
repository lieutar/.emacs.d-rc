(rc-ext
 :name 'snippet
 :get  "http://www.kazmier.com/computer/snippet.el"
 :init 
 (lambda ()

   ;;see also (browse-url "http://www.goodpic.com/mt/archives2/2007/02/emacs_snippetel_html.html")

   (dolist
       (spec
        '((local-abbrev-table
          ("htanc" . "<a href=\"$${url}\" title=\"$${title}\">$${title}</a>"))))
     (let ((table (car spec))
           (defs  (cdr spec)))
       (dolist (def defs)
         (eval `(snippet-with-abbrev-table ',table ,def)))))
   )
)
