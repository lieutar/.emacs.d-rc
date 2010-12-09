(rc-ext
 :load 'autoinsert
 :get  (lambda () (browse-url "http://www.emacswiki.org/emacs/AutoInsertMode"))
 :init
 (lambda ()
   (auto-insert-mode)  ;;; Adds hook to find-files-hook
   ;; Or use custom, *NOTE* Trailing slash important
   ;; !!!needs last slash!!!
   (setq auto-insert-directory "~/.emacs.d/templates/outline")
    ;; If you don't want to be prompted before insertion
   (setq auto-insert-query 'function)



   (defun my-auto-insert (tmpl)
     (insert-file-contents (concat auto-insert-directory tmpl))
     (goto-char (point-min))
     (let ((continue t))
       (while continue
         (if (re-search-forward "@\\([A-Z0-9a-z_\\-]+\\)@" nil t)
             (let ((back-to (point))
                   (replacement
                    (read-string (format "%s: " (match-string 1)))))
               (goto-char (match-beginning 0))
               (replace-string (match-string 0)
                               replacement)
               (goto-char back-to))
           (setq continue nil))))
     (goto-char (point-min))
     (replace-string "@@" "@"))


   (defconst my-rc-auto-insert-alist
     `((html-mode . "html5.html")))


   (setq
    auto-insert-alist
    (append
     (mapcar
      (lambda (slot)
        (let ((mode (car slot))
              (file (cdr slot)))
          (if (stringp file)
              (if (and (< 0 (length file))
                       (file-readable-p (concat auto-insert-directory
                                                file)))
                  (cons mode `(lambda () (my-auto-insert ,file)))
                (cons mode nil))
            (cons mode file))))
      my-rc-auto-insert-alist)
     auto-insert-alist))

   ))
