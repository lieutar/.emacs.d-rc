(require 'url)
(require 'cl)

(defconst rc-site-lisp (expand-file-name (concat "~/.emacs.d/rc/site-lisp."
                                                 rc-emacsen)))

(unless (file-exists-p rc-site-lisp)
  (make-directory rc-site-lisp))

(unless (member rc-site-lisp load-path)
  (setq load-path (cons rc-site-lisp load-path)))

(defun rc-url-retrieve (url)
  (let ((buffer (url-retrieve-synchronously url)))
       (save-excursion
         (set-buffer buffer)
         (goto-char (point-min))
         (re-search-forward "^$" nil 'move)
         (let ((header-max  (point))
               (headers     ())
               status
               http-version
               status-code
               status-message)
           (goto-char (point-min))
           (re-search-forward
            "^HTTP/\\([0-9\\.]+\\)\\s +\\([0-9]+\\)\\s +\\([^\n\r]+\\)"
            nil t nil)
           (setq status         (match-string 0))
           (setq http-version   (match-string 1))
           (setq status-code    (string-to-number (match-string 2)))
           (setq status-message (match-string 3))
           (let ((field   nil)
                 (content ""))
             (while (< (point) header-max)
               (next-line)
               (cond ((re-search-forward
                       "^\\([A-Za-z0-9\\-]+\\):\\s +\\([^\n\r]+\\)"
                       header-max t nil)
                      (when field
                        (setq headers (cons (cons field content) headers)))
                      (setq field   (match-string 1))
                      (setq content (match-string 2)))
                     ((re-search-forward
                       "^\\s +\\([^\r\n]+\\)" 
                       header-max t nil)
                      (setq content (concat content (match-string 1))))
                     (t
                      ()))
               )
             (when field
               (setq headers (cons (cons field content) headers))))
           (goto-char header-max)
           (next-line)
           (beginning-of-line)
           (delete-region (point-min) (point))
           `((url            . ,url)
             (status         . ,status)
             (http-version   . ,http-version)
             (status-code    . ,status-code)
             (status-message . ,status-message)
             (content        . ,buffer)
             ,@headers)))))

(defun rc-with-url (url callback &optional accept-statuses)
  (let* ((res  (rc-url-retrieve url))
         (code (cdr (assoc 'status-code res)))
         (asp  (cond ((null  accept-statuses)
                      (lambda (n) (and (> n 199) (< n 300))))
                     ((listp accept-statuses)
                      (lambda (n) (and (member n accept-statuses) t)))
                     ((functionp accept-statuses)
                      accept-statuses)
                     (t (error "wrong type argument: function or list")))))
    (if (apply asp (list code))
        (progn
          (apply callback (list (cdr (assoc 'content res)) res)))
      (throw 'illegal-http-code res))))

(defun rc-hexchar2num (chr)
  (if (< chr ?A)
      (- chr ?0)
    (+ 10 (- chr (if (< chr ?a) ?A ?a)))))

(defun rc-uri-decode (str)
  (let ((pos 0))
    (while (string-match "\\(%[0-9A-Fa-f][0-9A-Fa-f]\\|\\+\\)" str pos)
      (let* ((mstr (match-string    1 str))
             (head (substring str 0 (match-beginning 1)))
             (tail (substring str (match-end 1))))
        (setq pos (1+ (match-beginning 1)))
        (setq str (concat head
                          (if (equal mstr "+") " "
                            (string
                             (+ (* 16 (rc-hexchar2num (aref mstr 1)))
                                (rc-hexchar2num (aref mstr 2)))))
                          tail)))))
  str)

(defun rc-response-filename (res)
  (let ((url (replace-regexp-in-string "\\?.*$" ""
                                       (cdr (assoc 'url res)))))
    (when (and url
               (string-match "\\([^/]+\\)$" url))
      (rc-uri-decode (match-string 1 url)))))

(defun rc-get (url &optional not-compile)
  (rc-with-url
   url
   (lambda (buf res)
     (save-excursion
       (let ((filename
              (expand-file-name (concat rc-site-lisp "/"
                                        (rc-response-filename res)))))
         (set-buffer buf)
         (setq buffer-file-name filename)
         (replace-string "" "")
         (save-buffer)
         (kill-buffer buf)
         (unless not-compile (byte-compile-file filename))
         filename)))))


(defun rc-ext-internal (path load get init retry)
  (let ((rc-site-lisp
         (expand-file-name
          (if path
              (if (string-match "^\\(\\([a-zA-Z]:\\)?[/\\\\]\\|~\\)" path)
                  path
                (concat rc-site-lisp "/" path))
            rc-site-lisp))))
    (unless (member rc-site-lisp load-path)
      (setq load-path (cons rc-site-lisp load-path)))
    (unless (file-exists-p rc-site-lisp)
      (make-directory rc-site-lisp))
    (condition-case e
        (progn
          (apply load ())
          (apply init ())
          t)
      (error 
       (if retry
           (progn
             (apply get ())
             (rc-ext-internal path load get init nil))
         (message (format "%S" e))
         nil)))))

(defvar rc-ext-classes-alist ())

(defun rc-ext (&rest args)
  (let* ((name     (plist-get args :name    ))
         (funcs    (plist-get args :autoload))
         (class    (plist-get args :class   ))
         (path     (plist-get args :path    ))
         (load     (or (plist-get args :load)
                       name
                       (and (symbolp funcs) funcs)))
         (get      (plist-get args :get     ))
         (init     (plist-get args :init    ))

         (preload  (or (plist-get args :preload )
                       (lambda ())))

         (body    `(rc-ext-internal
                    ,path
                    ,(if (symbolp load)
                         `(lambda () (require ',load)) (or load (lambda ())))
                    ,(if (stringp get)
                         `(lambda () (rc-get ,get))    (or get  (lambda ())))
                    ,(or init (lambda ()))
                    t))

         (exec      (and
                     (apply (or (plist-get args :cond)
                                (lambda () t))
                            ())
                     (if class
                         (let ((classdef (assq class rc-ext-classes-alist)))
                           (and classdef
                                (eq name (cdr classdef))))
                       t))))
    (when exec
      (apply preload ())
      (if funcs
          (mapcar
           (lambda (slot)
             (let* ((slot (or (and (consp slot) slot)
                              (cons slot (format "%s" slot))))
                    (sym (car slot))
                    (desc (cdr slot)))
               (fset sym
                     `(lambda (&rest args)
                        ,desc
                        (interactive)
                        (fset ',sym nil)
                        (message "Loading ...")
                        (when ,body
                          (if (called-interactively-p)
                              (call-interactively ',sym)
                          (apply ',sym args)))))))
           (if (listp funcs)
               funcs
             (list funcs)))
        (eval body)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


