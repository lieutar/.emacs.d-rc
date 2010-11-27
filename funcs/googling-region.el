;;; ぐぐるコマンド

(defun googling-uri-encode (str &optional coding-system)
  "Encode string according to Percent-Encoding defined in RFC 3986."
  (let ((coding-system (or (when (and coding-system
				      (coding-system-p coding-system))
			     coding-system)
			   'utf-8)))
    (mapconcat
     (lambda (c)
       (cond
	((or (and (<= ?A c) (<= c ?Z))
	     (and (<= ?a c) (<= c ?z))
	     (and (<= ?0 c) (<= c ?9))
	     (eq ?. c)
	     (eq ?- c)
	     (eq ?_ c)
	     (eq ?~ c))
	 (char-to-string c))
	(t (format "%%%02X" c))))
     (encode-coding-string str coding-system)
     "")))



(defun googling-region (begin end)
  (interactive "r")
  (googling (buffer-substring-no-properties begin end)))


(defun googling (query)
  (interactive (list (if mark-active
                         (buffer-substring-no-properties(region-beginning)
                                                        (region-end))
                       (read-string "google: "))))
  (let* ((url   (format "http://google.com/search?q=%s"
                        (googling-uri-encode query))))
    (browse-url url)))
