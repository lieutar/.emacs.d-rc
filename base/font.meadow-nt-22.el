(let ((make-spec 
       (function 
	(lambda (size charset fontname &optional windows-charset)
	  (setq size (- size))
	  (if (not windows-charset)
	      (setq windows-charset 
		    (cadr (assq charset mw32-charset-windows-font-info-alist))))
	  `(((:char-spec ,charset :height any)
	     strict
	     (w32-logfont ,fontname 0 ,size 400 0 nil nil nil
			  ,windows-charset 1 3 0))
	    ((:char-spec ,charset :height any :weight bold)
	     strict
	     (w32-logfont ,fontname 0 ,size 700 0 nil nil nil
			  ,windows-charset 1 3 0)
	     ((spacing . -1)))
	    ((:char-spec ,charset :height any :slant italic)
	     strict
	     (w32-logfont ,fontname 0 ,size 400 0   t nil nil
			  ,windows-charset 1 3 0))
	    ((:char-spec ,charset :height any :weight bold :slant italic)
	     strict
	     (w32-logfont ,fontname 0 ,size 700 0   t nil nil
			  ,windows-charset 1 3 0)
	     ((spacing . -1)))))))

       (make-spec-list
	(function
	 (lambda (size params-list)
	   (list (cons 'spec 
		       (apply 'append 
			      (mapcar (lambda (params)
					(apply make-spec (cons size params)))
				      params-list))))
	   )))

       (define-fontset 
	 (function
	  (lambda (fontname size fontset-list)
	    (let ((spec (funcall make-spec-list size fontset-list)))
	      (if (w32-list-fonts fontname)
		  (w32-change-font fontname spec)
		(w32-add-font fontname spec)
		))))))

  (dolist (fontspec '(("Serif"
		       ((ascii             "MS Mincho")
			(katakana-jisx0201 "MS Mincho")
			(japanese-jisx0208 "MS Mincho")
			(korean-ksc5601    "Batang")
			(chinese-gb2312    "SimSun")
			(chinese-big5-1    "MingLiU")
			(chinese-big5-2    "MingLiU")))

		      ("Gothic"
		       ((ascii             "MS Gothic")
			(katakana-jisx0201 "MS Gothic")
			(japanese-jisx0208 "MS Gothic")
			(korean-ksc5601    "Dotum")
			(chinese-gb2312    "SimHei")
			(chinese-big5-1    "MingLiU")
			(chinese-big5-2    "MingLiU")))))

    (dolist (size '(11 12 14 16 18 20 22 24 36 48))
      (funcall define-fontset
               (format "%s %s" (car fontspec) size)
               size
               (cadr fontspec)))))

(add-to-list 'default-frame-alist '(font . "Gothic 11"))
(add-to-list 'default-frame-alist '(height . 81))
(modify-frame-parameters (selected-frame) default-frame-alist)

