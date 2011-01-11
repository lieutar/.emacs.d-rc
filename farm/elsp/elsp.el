;;(add-to-list 'load-path default-directory)

(defvar elsp:default-color-scheme 
  (let* ((alist (frame-parameters nil))
         (fore  (cdr (or (assq 'foreground-color alist) '(nil))))
         (bg    (cdr (or (assq 'background-color alist) '(nil)))))
    (cons fore bg)))
(defvar elsp:perspective-alist '((default
                                  :composition nil)))

(defvar elsp:window-plist nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsubst elsp:update-window-plist (name composition)
  (setq elsp:window-plist
        (cons name
              (cons (append
                     composition
                     (list :window   (selected-window)))
                    elsp:window-plist))))
;;(setq elsp:window-plist nil)
;;(elsp:update-window-plist 'xxx '())
;;(elscreen-create)

(defun elsp:init-window (composition)
  (let ((init (or (plist-get composition :init)
                  (lambda ())))
        (name (plist-get composition :name)))
    (when name (elsp:update-window-plist name composition))
    (funcall init)))

(defun elsp:split-window (composition)
  (let* ((type    (caar composition))
         (details (cdr  composition))
         (sizes   (mapcar (lambda (slot)
                            (plist-get (if (and (consp slot)
                                                (keywordp (car slot)))
                                           slot
                                         (cdar slot)) :size)) details))
         (windows ())
         (index   0))
    (while sizes
      (let ((size (car sizes)))
        (setq sizes (cdr sizes))
        (setq windows (cons (selected-window) windows))
        (when sizes
          (split-window nil size (eq type '|)))
        (other-window 1)))
    (dolist (win (reverse windows))
      (select-window win)
      (elsp:set-composition
       (nth index details))
      (setq index (1+ index)))))

(defun elsp:set-composition (composition)
  (when composition
    (cond
     ((keywordp (car composition))
      (elsp:init-window composition))
     ((listp    (car composition))
      (elsp:split-window composition))
     (t (error "malformed specification")))))

(defun elsp:perspective:get (name)
  (cdr (or (assq name elsp:perspective-alist)
           (assq 'default elsp:perspective-alist)
           '(nil))))

(defun elsp:init (name)
  (let* ((plist       (elsp:perspective:get name))
         (preinit     (plist-get plist :preinit))
         (focus-to    (plist-get plist :focus))
         (composition (plist-get plist :composition))
         (elsp:window-plist))
    (when preinit (funcall preinit))
    (delete-other-windows)
    (setq elsp:focus-window (selected-window))
    (elsp:set-composition composition)
;;    (message "%S" elsp:window-plist)
    (when focus-to
      (let ((win (plist-get (plist-get elsp:window-plist
                                       focus-to)
                            :window)))
        (when win (select-window win))))
    (cons name elsp:window-plist)))

(defun elsp:switch (name)
  (let* ((perspective (elsp:perspective:get name))
         (color       (or (plist-get perspective :color)
                          elsp:default-color-scheme)))
    (modify-frame-parameters
     nil
     `((foreground-color . ,(car color))
       (background-color . ,(cdr color))))))


;;(elsp:init 'main)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst elsp:current-window-plist nil)
(defconst elsp:initialized-flags   (make-hash-table :test 'eq))
(defvar elsp:perspective-setting  ())

(defun elsp:get-window-plist-by-name (name)
  (plist-get (cdr elsp:current-window-plist) name))


(defun elsp:pop-to:get-window (name)
  (let ((pop-to
         (when elsp:current-window-plist
           (or (when name
                 (plist-get (elsp:get-window-plist-by-name name)
                            :pop-to))
               (plist-get (elsp:perspective:get
                           (car elsp:current-window-plist))
                          :pop-to)))))
    (when pop-to
      (plist-get (plist-get (cdr elsp:current-window-plist) pop-to)
                 :window))))

(defun elsp:get-window-properties (&optional win)
  (let ((win   (selected-window))
        (rest   elsp:current-window-plist)
        (result nil))
    (while rest
      (let ((slot (car rest)))
        (setq rest (cdr rest))
        (when (and slot (listp slot))
          (let ((swin (plist-get slot :window)))
            (when (eq swin win)
              (setq result slot)
              (setq rest nil))))))
    result))




;; pop-to-buffer は、display-buffer を内部的に呼び出している。
(defun elsp:display-buffer-function (buffer &optional other-window)
  (let* ((props  (elsp:get-window-properties))
         (name   (plist-get props :name))
         (pop-to (elsp:pop-to:get-window name)))
    (if (and pop-to (window-live-p pop-to))
        pop-to
      (let* ((windows (window-list))
             (member  (member (selected-window) windows)))
        (cond ((> (length member ) 1) (cadr member))
              ((> (length windows) 1) (car windows))
              ;; ここ、手抜きね。
                    ;;                    (other-window )
              (t (selected-window)))))))

;;(setq display-buffer-function nil)
;;(setq display-buffer-function 'elsp:display-buffer-function)
(defadvice pop-to-buffer (around elsp:ad first
                                 (buffer-or-name
                                  &optional other-window norecord)
                                 activate)
  (let ((win (elsp:display-buffer-function buffer-or-name other-window)))
    (if win
        (progn (select-window win)
               (switch-to-buffer buffer-or-name))
      ad-do-it)))

;;(ad-disable-advice 'pop-to-buffer 'around 'elsp:window-el-advices)


(defadvice select-window (around elsp:ad last
                                 (window &optional norecord)
                                 activate)
  (let* ((R       ad-do-it)
         (plist   (elsp:get-window-properties))
         (onfocus (plist-get plist :onfocus)))
    (when onfocus (funcall onfocus))
    R))


;;(completing-read "which perspective? " elsp:perspective-alist nil t)

(defconst elsp:next-perspective-name nil)

(defun elsp:create (perspective-name)
  (interactive (list (intern (completing-read "which perspective? "
                                              elsp:perspective-alist nil t))))
  (setq elsp:next-perspective-name perspective-name)
  (elscreen-create))

(defun elsp:after-goto ()
  (let* ((screen  (elscreen-get-current-screen))
         (windows (gethash screen elsp:initialized-flags)))
    (unless windows
      (let ((scheme (or elsp:next-perspective-name
                        (plist-get elsp:perspective-setting
                                   (elscreen-get-current-screen))
                        'default)))
        (setq windows (elsp:init   scheme))
        (elsp:switch scheme))
      (puthash screen windows elsp:initialized-flags))
    (setq elsp:next-perspective-name nil)
    (setq elsp:current-window-plist windows)))

(add-hook 'elscreen-goto-hook 'elsp:after-goto)

(defadvice elscreen-kill (around
                          elsp:elscreen-advices
                          activate)
  (let ((screen (elscreen-get-current-screen)))
    (puthash screen nil elsp:initialized-flags))
  ad-do-it)

(defun elsp:modify-frame-color ()
  (elsp:switch (or (plist-get elsp:perspective-setting
                              (elscreen-get-current-screen))
                   'default)))
(add-hook 'elscreen-screen-update-hook 'elsp:modify-frame-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun elsp:set-environment (setting env)
  (setq elsp:perspective-setting setting)
  (setq elsp:perspective-alist   env))

;;(kill-other-emacses)
(provide 'elsp)
