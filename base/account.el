(require 'acman)

(let ((mail (acman-get-property "*about*" "*me*" "email")))
  (setq g-user-email      mail)
  (setq gcal-user-email     mail)
  (setq gblogger-user-email mail)
  (setq kael-hatena-user-alist
        (acman-get-property-alist "hatena.ne.jp" "password")))

