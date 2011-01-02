(rc-ext
 :name 'hatena-let-mode
 :load 'hatena-let
 :requires '(
             deferred
             js2
             )
 :get (concat "https://gist.github.com/raw/"
              "662175/80dafc5664e1085ba223357ae63dd65314f387bd/hatena-let.el")
 :autoload '(
             hatena-let/edit
             hatena-let-mode
             )
 :init
 (lambda ()

   (setq hatena-let/apikey
         (acman-get "hatena.ne.jp lieutar Hatena::Let/api-key"))

   (defconst hatena-let-mode-map
     (let ((km (make-sparse-keymap)))
       (define-key km (kbd "C-x C-s") 'hatena-let-mode/save-code)
       km))

   (defun hatena-let-mode/save-code ()
     (interactive)
     (save-buffer)
     (hatena-let/save-code)
     (hatena-let-mode))

   (define-derived-mode hatena-let-mode js2-mode "hatena-let" ""
     )

   (defun hatena-let/edit ()
     (interactive)
     (let ((buf (get-buffer-create "*hatena-let*")))
       (switch-to-buffer buf)
       (deferred:$

         (deferred:url-post 
           "http://let.hatelabo.jp/api/code"
           `(("api_key" . ,hatena-let/apikey)))

         (deferred:nextc it
           `(lambda (gbuf)
              (set-buffer ,buf)
              (goto-char (point-min))
              (insert
               (save-excursion
                 (set-buffer gbuf)
                 (decode-coding-string
                  (buffer-substring-no-properties (point-min) (point-max))
                  'utf-8)))
              (hatena-let-mode)
              (goto-char (point-min))))

         );; end of deferred:$
       );; end of let
     );; end of defun

   ))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;