;;-*- coding: utf-8 -*-
(rc-ext
 :load (lambda ()
         (require 'remember)
         (require 'org-install)
         )

 :autoload
 '(org-mode
   org-store-link
   org-agenda
   org-remember-code-to-do
   org-remember)

 :preload
 (lambda ()
   (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
   (define-key global-map "\C-cl" 'org-store-link)
   (define-key global-map "\C-ca" 'org-agenda)
   (setq org-directory "~/memo/")
   (global-set-key
     (kbd "C-z a") (lambda ()
                     (interactive)
                     (find-file (expand-file-name
                                 "agenda.org"
                                 org-directory))))

   )

 :get
 (lambda ()
   (browse-url "http://orgmode.org/index.html")
   (browse-url "http://repo.or.cz/w/remember-el.git")
   )
 :init
 (lambda ()

   ;;;
   (setq org-startup-truncated nil)
   (setq org-return-follows-link t)

   (setq org-hide-leading-stars t)
   (setq org-log-done t)

   (org-remember-insinuate)

   
  (setq org-default-notes-file (concat org-directory "agenda.org"))
   (setq org-remember-templates
         '(("Todo" ?t "** TODO %?\n   %i\n   %a\n   %t" nil "Inbox")
           ("Bug" ?b "** TODO %?   :bug:\n   %i\n   %a\n   %t" nil "Inbox")
           ("Idea" ?i "** %?\n   %i\n   %a\n   %t" nil "New Ideas")
           ))

   (defun org-remember-code-to-do ()
     (interactive)
     (save-excursion
         (let* ((to (point))
                (todo
                 (progn
                   (search-backward "TODO")
                   (buffer-substring-no-properties (+ 4 (point)) to))
                 )
                (org-remember-templates
                 `(("TODO" ?r "** TODO %(identity todo)%?\n   \n   %a\n   %t"
                    ,org-default-notes-file
                    "Inbox"))))
           (goto-char to)
           (call-interactively 'org-remember))))


   

   ;;;
   ;;; code-reading
   ;;;
   ;;; http://d.hatena.ne.jp/rubikitch/20090121/1232468026
   ;;;

   (defvar org-code-reading-software-name nil)
   ;; ~/memo/code-reading.org に記録する
   (defvar org-code-reading-file "code-reading.org")
   (defun org-code-reading-read-software-name ()
     (set (make-local-variable 'org-code-reading-software-name)
          (read-string "Code Reading Software: " 
                       (or org-code-reading-software-name
                           (file-name-nondirectory
                            (buffer-file-name))))))

   (defun org-code-reading-get-prefix (lang)
     (concat "[" lang "]"
             "[" (org-code-reading-read-software-name) "]"))
   (defun org-remember-code-reading ()
     (interactive)
     (let* ((prefix (org-code-reading-get-prefix
                     (substring (symbol-name major-mode) 0 -5)))
            (org-remember-templates
             `(("CodeReading" ?r "** %(identity prefix)%?\n   \n   %a\n   %t"
                ,org-code-reading-file "Memo"))))
       (org-remember)))
   
   (define-key org-mode-map (kbd "C-c <up>")    'org-shiftup)
   (define-key org-mode-map (kbd "C-c <down>")  'org-shiftdown)
   (define-key org-mode-map (kbd "C-c <left>")  'org-shiftleft)
   (define-key org-mode-map (kbd "C-c <right>") 'org-shifright)

   (define-key org-mode-map (kbd "C-z <right>") 'org-demote-subtree)
   (define-key org-mode-map (kbd "C-z <left>")  'org-promote-subtree)
   
   (define-key org-mode-map (kbd "S-<up>") nil)
   (define-key org-mode-map (kbd "S-<down>") nil)
   (define-key org-mode-map (kbd "S-<left>") nil)
   (define-key org-mode-map (kbd "S-<right>") nil)
   )
)
