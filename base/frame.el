(modify-frame-parameters
 nil
 (setq default-frame-alist
       (append

        '((scroll-bar-width . 12)
          (tool-bar-lines   .  0))

        (rc-emacsen-case
         (fsf-cygwin-@
          '()))

        default-frame-alist)))

(rc-emacsen-case
 (@-@-23
  (setq tool-bar-mode t)
  (tool-bar-mode nil)))

;;(let ((params (frame-parameters (selected-frame)))) (assq (intern (completing-read "prop: " params)) params))