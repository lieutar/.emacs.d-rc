(rc-ext
 :class    'edit-json
 :name     'json-javascript-mode
 :load     (lambda () (load-library "javascript"))
 :get      "http://www.brgeight.se/downloads/emacs/javascript.el"
 :autoload 'json-mode
 :preload  (lambda ()
             (add-to-list 'auto-mode-alist
                          '("\\.json\\'" . json-mode)))
 :init
 (lambda ()
   (define-derived-mode json-mode javascript-mode "json")

   ;; TODO json.el のデータを使って、正規表現テーブルを作ってみるとか
   (defconst json-mode-lex-regexps
     '((json-read-string "\"\\(\\(\\)\\)\"" 1
                         (lambda ()
                           ))
       (json-read-object ".")
       ()))

   )
)

