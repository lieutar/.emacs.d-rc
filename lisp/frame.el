;; 
(rc-load "font")

(modify-frame-parameters
 nil
 (setq default-frame-alist
       (append

        '((scroll-bar-width .  8)
          (tool-bar-lines   .  0))

        (when (> (x-display-pixel-width) 800)
          `((width  . ,(rc-emacsen-case 
                        (@-cygwin-23 252)
                        (t           
                         (cond
                          ((equal system-name "cotreefrog")
                           251)
                          ((equal system-name "comisuzu")
                           251)
                          (t 166)))))))

        (rc-emacsen-case
         (fsf-cygwin-@
          '((top              . 21)
            (left             .  0)
            (left-fringe      .  4)
            (right-fringe     .  4))))

        default-frame-alist)))


(rc-emacsen-case
 (@-@-23
  (tool-bar-mode -1)))

;;(let ((params (frame-parameters (selected-frame)))) (assq (intern (completing-read "prop: " params)) params))
;;(emacs-pid)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

