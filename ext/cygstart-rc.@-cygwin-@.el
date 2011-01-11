(rc-ext
 :name 'cygstart
 :load 'cygstart
 :autoload '(cygstart
             dired-cygstart
             cygstart-explore
             dired-cygstart-explore
             dired-mouse-cygstart)
 :preload 
 (lambda ()
   (require 'dired)
   (define-key dired-mode-map [f3] 'dired-cygstart)
   (define-key dired-mode-map [f4] 'dired-cygstart-explore)
   (define-key dired-mode-map [menu-bar immediate dired-cygstart]
     '("Open Associated Application" . dired-cygstart))
   (define-key dired-mode-map [mouse-2] 'dired-mouse-cygstart)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(rc-ext
 :name 'anything-quicklaunch-cygstart
 :load nil
 :requires '(cygstart
             anything)
 :autoload '(anything-quicklaunch-cygstart
             anything-quicklaunch)
 :init
 (lambda ()

   (defvar anything-quicklaunch-cygstart-path
     (concat "/cygdrive/c/Users/"
             user-login-name
             "/AppData/Roaming/Microsoft/"
             "Internet Explorer/Quick Launch"))

   (defconst anything-c-source-quicklaunch-cygstart
     '((name . "Quick Launch")
       (candidates
        . (lambda ()
            (apply 'append
                   (mapcar
                    (lambda (file)
                      (when (string-match "\\(.*?\\)\\.lnk\\'" file)
                        (list (cons
                               (match-string 1 file)
                               (expand-file-name
                                file anything-quicklaunch-cygstart-path)))))
                    (directory-files
                     anything-quicklaunch-cygstart-path)))))
       (action
        . (("Launch" . cygstart)))))

   (defun anything-quicklaunch-cygstart ()
     (interactive)
     (anything :sources '(anything-c-source-quicklaunch-cygstart)))

   (defalias 'anything-quicklaunch 'anything-quicklaunch-cygstart)
   ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(rc-ext
 :name 'cygstart:anything-add-type
 :load nil
 :requires '(anything)
 :init
 (lambda ()
   (let ((action-slot (assoc
                       'action (cdr (assoc 'file anything-type-attributes)))))
     (setcdr action-slot
             (append (cdr action-slot)
                     '(("Cygstart" . cygstart)
                       ("Cygstart Explorer" . cygstart-explore)))))))
