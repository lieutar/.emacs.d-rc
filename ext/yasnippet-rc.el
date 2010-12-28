(rc-ext
 :name 'yasnippet
 :load (lambda ()
         (require 'yasnippet)
         (require 'dropdown-list)
         )
;;  :autoload '(yas/expand
;;              yas/load-directory
;;              yas/insert-snippet
;;              yas/find-snippets
;;              yas/visit-snippet-file
;;              yas/new-snippet
;;              yas/load-snippet-buffer
;;              yas/tryout-snippet)
 :get (lambda () (browse-url "http://code.google.com/p/yasnippet/"))
 :init
 (lambda ()
   (setq yas/root-directory "~/.emacs.d/templates/snippet")
   (yas/load-directory yas/root-directory)
;;   (yas/global-mode nil)
   (setq yas/prompt-functions '(yas/dropdown-prompt
                                yas/ido-prompt
                                yas/completing-prompt))


;;;
;;; SEE ALSO "http://d.hatena.ne.jp/rubikitch/20101204/yasnippet"
;;;
;;; [2010/07/13]
   (defun yas/expand-link (key)
     "Hyperlink function for yasnippet expansion."
     (delete-region (point-at-bol) (1+ (point-at-eol)))
     (insert key)
     (yas/expand))
;;; [2010/12/02]
   (defun yas/expand-link-choice (&rest keys)
     "Hyperlink to select yasnippet template."
     (yas/expand-link (completing-read "Select template: " keys nil t)))
   ;; (yas/expand-link-choice "defgp" "defcm")

   ))
