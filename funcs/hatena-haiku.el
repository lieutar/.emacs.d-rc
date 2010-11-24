(setq hatena-user-alist '(("lieutar" . "shellfish")
                          ("lieutax" . "shellfish")))

(require 'url)
;;(require 'base64)

(assoc "h.hatena.ne.jp:80" (symbol-value url-basic-auth-storage))
(defvar   hatena-user-alist   nil)
(defvar   hatena-default-user-name (and hatena-user-alist
                                        (caar hatena-user-alist)))
(defconst hatena-current-user nil)

(defun hatena-login (username)
  (interactive
   (list (completing-read "username: "
                          (mapcar 'car hatena-user-alist))))
  (unless (equal hatena-current-user username)
    (let ((slot (assoc username hatena-user-alist)))
      (if slot
          (let ((buf (hatena-haiku-post
                      hatena-haiku-login-uri
                      `(("name"     . ,username)
                        ("password" . ,(cdr slot))
                        ("persistent" . "1")))))
            (save-excursion
              (set-buffer buf)
              ;; TODO ログインの失敗をちゃんと書く
              (setq hatena-current-user username)
              (kill-buffer buf)))))))


(defvar hatena-haiku-user-name nil)
(defvar hatena-haiku-password  nil)
(defvar hatena-haiku-client-name "hatena-haiku.el")
(defconst hatena-haiku-cookies-alist nil)

(defvar
  hatena-haiku-post-uri
  "http://h.hatena.ne.jp/api/statuses/update.json")

(defvar
  hatena-haiku-login-uri
  "https://www.hatena.ne.jp/login")


(defun hatena-haiku-make-query (req)
  (mapconcat 
   (lambda (x) x)
   (apply
    'append
    (mapcar
     (lambda (kvp)
       (let ((key (car kvp))
             (val (cdr kvp)))
         (when val
           (list (format "%s=%s"
                         (url-hexify-string key)
                         (url-hexify-string val))))))
     req))
   "&")
  )


(defun hatena-haiku-post (url req &optional headers)
  (let ((url-request-method        "POST")
        (url-request-extra-headers 
         (append headers
                 `(("Content-type" . "application/x-www-form-urlencoded")
                   )))
        (url-request-data          (hatena-haiku-make-query req)))
    (url-retrieve-synchronously url)))



;;
;; TODO BASIC 認証をキャンセルして失敗を拾えるようにする
(defun hatena-haiku-update (&rest opts)

  (hatena-login (or (plist-get opts :user)
                    (or hatena-current-user
                        hatena-default-user-name)))

  (let ((buf (hatena-haiku-post
              hatena-haiku-post-uri
              `(("status"                . ,(plist-get opts  :status ))
                ("keyword"               . ,(plist-get opts  :keyword))
                ("in_reply_to_status_id" . ,(plist-get opts  :reply-to))
                ("source"                . ,(or
                                             (plist-get opts  :source)
                                             hatena-haiku-client-name)))
              `(
                ("Authorization" . ,(base64-encode-string
                                     (format "%s:%s"
                                             hatena-haiku-user-name
                                             hatena-haiku-password)))
                ))))


    (apply (or (plist-get opts :callback)
               (lambda (buf)
                 (message "Done.")
                 (kill-buffer buf)))
           (list buf))))

(defun hatena-haiku-region (begin end &optional keyword)
  (interactive "r")
  ;;
  (when current-prefix-arg (setq keyword (read-string "keyword: ")))
  (apply 'hatena-haiku-update
         :status (buffer-substring-no-properties begin end)
         (append (when keyword (list :keyword keyword)))))

