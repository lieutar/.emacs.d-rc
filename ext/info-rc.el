(require 'info)
(rc-load "rc-vise-km")
(rc-vise-km Info-mode-map)
(define-key Info-mode-map (kbd "M-l") 'Info-history-back)

(rc-emacsen-case
 (@-nt-@
  (add-to-list 'Info-default-directory-list "c:/cygwin/usr/info/")))

(rc-emacsen-case
 (meadow-nt-@
  (add-to-list 'Info-default-directory-list
               "c:/meadow/info")
  (add-to-list 'Info-default-directory-list
               "c:/meadow/packages/info")))
