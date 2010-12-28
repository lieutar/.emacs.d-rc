(modify-frame-parameters
 (selected-frame)
 (setq default-frame-alist
       (append (rc-emacsen-case
                (fsf-cygwin-@
                 '((scroll-bar-width . 12)
                   (tool-bar-lines   . 0))))
               default-frame-alist)))


;;(let ((params (frame-parameters (selected-frame)))) (assq (intern (completing-read "prop: " params)) params))