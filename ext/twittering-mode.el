(rc-ext
 :load 'twittering-mode
 :autoload 'twit
 :get  "http://github.com/hayamiz/twittering-mode/raw/master/twittering-mode.el"
 :init
 (lambda ()
   (require 'cl)

   (defun my-twittering-mode-hook ()
     (twittering-icon-mode t)
     (mapcar
      (lambda (slot)
        (define-key twittering-mode-map (macroexpand
                                         `(kbd ,(car slot))) (cadr slot)))
   '(("F" twittering-favorite)
     ("R" twittering-retweet))))
   (add-hook 'twittering-mode-hook 'my-twittering-mode-hook)

   (setq twittering-auth-method 'xauth)
   (setq twittering-username (acman-get-username "twitter.com"))
   (setq twittering-password (acman-get-property "twitter.com"
                                                 twittering-username
                                                 "password"))


   (rc-emacsen-case
    (meadow-nt-22
     (setq twittering-connection-type-order
           '(
             ;;curl
             wget
             native
             ))
     ))
   
   ))
