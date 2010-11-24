(defvar kill-old-buffers-buffers-length 0)
(defvar kill-old-buffers-temporary-major-mode-name
  '(grep-mode))

;; (defun kill-old-buffers:time= (a b)
;;   (and (= (car  a)(car b))
;;        (= (cadr a)(cadr b))))

;; (defun kill-old-buffers:time< (a b)
;;   (or (< (car a)(car b))
;;       (and (= (car a)(car b))
;;            (< (cadr a)(cadr b)))))

;; (defun kill-old-buffers:time< (a b)
;;   (or (> (car a)(car b))
;;       (and (= (car a)(car b))
;;            (> (cadr a)(cadr b)))))


(defun kill-old-buffers:buffer-value (buffer sym)
  (let (r)
    (save-excursion
      (set-buffer buffer)
      (setq r (symbol-value sym)))
    r))




(defun kill-old-buffers ()
  (interactive)
  (let* ((blist (buffer-list))
	 (len (length blist)))

    (while blist
      (let* ((b          (car blist))
	     (major-mode (kill-old-buffers:buffer-value b 'major-mode)))

	(setq blist (cdr blist))

	(when (cond

	       ;;
	       ((and (buffer-file-name  b)
                     (not (buffer-modified-p b)))
		(let ((file (buffer-file-name b)))
		  (verify-visited-file-modtime (current-buffer))))

	       ;;
	       ((eq major-mode 'dired-mode)
		(not (file-exists-p (kill-old-buffers:buffer-value
				     b
                                     'dired-directory))))

               ;;
               ((member (kill-old-buffers:buffer-value
                         b
                         'major-mode) 
                        kill-old-buffers-temporary-major-mode-name))

	       ;;
	       (t
		(let ((file (buffer-file-name b)))
		  (or (not file)
		      (file-exists-p file)
		      (verify-visited-file-modtime b)
		      )))) ;; end of cond
	  

	  (kill-buffer b)
	  (when (< (setq len (1- len))
		   kill-old-buffers-buffers-length)
	    (setq blist nil))) ;; end of (when


	));; end of (while blist
    ));; end of function
