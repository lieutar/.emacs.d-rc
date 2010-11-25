(setq

 find-git-exclude-patterns-list
 '("/rc/site-lisp\\."
   "/\\.mozilla")

 find-git-exclude-pathes-list
 '("~/.ie"
   "~/smb"
   "~/sandbox"
   "~/Desktop"
   "~/.cpan"
   "~/.cpanm"
   "~/.cpanplus"
   "~/.ies4linux"
   "~/.macromedia"
   "~/.wine"
   "~/work/build"
   )

 find-git-nested-tree-list
 ()

 )

(defvar find-git-nested-tree-list ())
(defvar find-git-exclude-pathes-list ())
(defvar find-git-exclude-patterns-list ())
(defvar find-git--visited-dir ())

(defun find-git--exclude-pattern ()
  (mapconcat
   #'identity
   (append
    (list "\\.git\\'")
    find-git-exclude-patterns-list
    (mapcar (lambda (x)
              (format "\\`%s\\'"(regexp-quote
                                 (expand-file-name x))))
            find-git-exclude-pathes-list)
    )
   "\\|"))

(defun find-git--nested-tree-pattern ()
  (mapconcat
   (lambda (x)
     (format "\\`%s\\'"(regexp-quote
                        (expand-file-name x))))
   find-git-nested-tree-list
   "\\|")
  )

(defun find-git--walk-dir (base cb)
  (unless (eq :stop (apply cb (list base)))
    (dolist (sub (directory-files (expand-file-name base)))
      (let ((full (expand-file-name (concat base "/" sub))))
        (when (and (not (string-match "\\`\\.\\.?\\'" sub))
                   (file-directory-p full)
                   (file-readable-p full))
          (find-git--map-dir full cb))))))

(defun find-git (base)
  (interactive (list (read-directory-name "base: ")))
  (let ((xpat (find-git--exclude-pattern))
        (npat (find-git--nested-tree-pattern)))
    (find-git--map-dir
     base
     (lambda (path)
       (message path)
       (cond ((string-match xpat path) :stop)
             ((file-directory-p (expand-file-name (concat path "/.git")))
              (insert path "\n")
              (unless (string-match npat path) :stop)))))))



