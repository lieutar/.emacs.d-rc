(rc-ext
 :cond
 (lambda ()
   (equal 'windows-nt system-type))
 :load
 (lambda ()
   (require 'w32-symlinks)
   (require 'w32-browser)
   )

 :get
 (lambda ()
   (rc-get
    "http://www.emacswiki.org/emacs/download/w32-browser.el")
   (rc-get
    "http://centaur.maths.qmw.ac.uk/emacs/files/w32-symlinks.el")
   )

 :init
 (lambda ()

   (add-to-list 'w32-symlinks-dired-support 'parse-old-symlinks)
   ;; w32-symlinks-dired-support
   ;; dired-mode-map
   
   (define-key dired-mode-map [f3] 'dired-w32-browser)
   (define-key dired-mode-map [f4] 'dired-w32explore)
   (define-key dired-mode-map [menu-bar immediate dired-w32-browser]
     '("Open Associated Application" . dired-w32-browser))
   
   (define-key dired-mode-map [mouse-2] 'dired-mouse-w32-browser)
   (define-key dired-mode-map [menu-bar immediate dired-w32-browser]
     '("Open Associated Applications" . dired-multiple-w32-browser))
   
   
   (defun w32-symlinks-parse-old-Cygwin (file)
     "Return file or directory referenced by obsolete Cygwin symbolic link FILE.
Return nil if the file cannot be parsed."
     (setq hoge file)
     (with-temp-buffer
       ;; Read at most the first 512 bytes for efficiency:
       (insert-file-contents-literally file nil 0 511) ; Eli Zaretskii
       (cond ((looking-at "!<symlink>\xff\xfe\\(.*\\)")
              (w32-symlinks-Cyg-to-Win
               (decode-coding-string 
                (replace-regexp-in-string "\000" "" 
                                            (match-string-no-properties 1))
                file-name-coding-system)))
             ((looking-at "!<symlink>\\(.+\\)\0")
              (setq file (match-string-no-properties 1))
              (decode-coding-string file file-name-coding-system) ; Eli Zaretskii
              ))))
   

   ))
