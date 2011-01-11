
;; 各所にパスを通す
(let ((subdirs (locate-library "subdirs.el")))
  (dolist (dir
            (append
             '("~/share/emacs/site-lisp"
               "~/work/emacs"
               "~/.emacs.d/rc/farm")
             (rc-emacsen-case
              (fsf-cygwin-@
               ;; なぜか、user/local/share/site-lisp に
               ;; デフォルトでパスが通っていない
               ;; cygwin のために
               '("/usr/local/share/emacs/site-lisp")))))
    (let ((default-directory (expand-file-name dir)))
      (when (and (file-readable-p default-directory)
                 (file-directory-p default-directory))
        (unless (file-exists-p "./subdirs.el")
          (copy-file subdirs "./subdirs.el"))
      (unless (member default-directory load-path)
        (add-to-list 'load-path default-directory))
      (load "./subdirs.el")))))

