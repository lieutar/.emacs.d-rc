;;; elsx.el --- 

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

;;(add-to-list 'load-path default-directory)

(defvar elsx:default-color-scheme 
  (let* ((alist (frame-parameters nil))
         (fore  (cdr (or (assq 'foreground-color alist) '(nil))))
         (bg    (cdr (or (assq 'background-color alist) '(nil)))))
    (cons fore bg)))
(defvar elsx:perspective-alist '((default
                                  :composition nil)))

(defvar elsx:window-plist nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defsubst elsx:update-window-plist (name composition)
  (setq elsx:window-plist
        (cons name
              (cons (append
                     composition
                     (list :window   (selected-window)))
                    elsx:window-plist))))
;;(setq elsx:window-plist nil)
;;(elsx:update-window-plist 'xxx '())
;;(elscreen-create)

(defun elsx:init-window (composition)
  (let ((init (or (plist-get composition :init)
                  (lambda ())))
        (name (plist-get composition :name)))
    (when name (elsx:update-window-plist name composition))
    (funcall init)))

(defun elsx:split-window (composition)
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
          (split-window nil nil (eq type '|)))
        (when size
          (let ((cursize (if (eq type '|) (window-width nil)
                           (window-height nil))))
            (if (> size cursize)
                (enlarge-window (- size cursize) (eq type '|))
              (shrink-window (- cursize size) (eq type '|)))))
        (other-window 1)))
    (dolist (win (reverse windows))
      (select-window win)
      (elsx:set-composition
       (nth index details))
      (setq index (1+ index)))))

(defun elsx:set-composition (composition)
  (when composition
    (cond
     ((keywordp (car composition))
      (elsx:init-window composition))
     ((listp    (car composition))
      (elsx:split-window composition))
     (t (error "malformed specification")))))

(defun elsx:perspective:get (name)
  (cdr (or (assq name elsx:perspective-alist)
           (assq 'default elsx:perspective-alist)
           '(nil))))

(defun elsx:init (name)
  (let* ((plist       (elsx:perspective:get name))
         (preinit     (plist-get plist :preinit))
         (focus-to    (plist-get plist :focus))
         (composition (plist-get plist :composition))
         (elsx:window-plist))
    (when preinit (funcall preinit))
    (delete-other-windows)
    (setq elsx:focus-window (selected-window))
    (elsx:set-composition composition)
;;    (message "%S" elsx:window-plist)
    (when focus-to
      (let ((win (plist-get (plist-get elsx:window-plist
                                       focus-to)
                            :window)))
        (when win (select-window win))))
    (cons name elsx:window-plist)))

(defun elsx:switch (name)
  (let* ((perspective (elsx:perspective:get name))
         (color       (or (plist-get perspective :color)
                          elsx:default-color-scheme)))
    (modify-frame-parameters
     nil
     `((foreground-color . ,(car color))
       (background-color . ,(cdr color))))))


;;(elsx:init 'main)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defconst elsx:current-window-plist nil)
(defconst elsx:initialized-flags   (make-hash-table :test 'eq))
(defvar elsx:perspective-setting  ())

(defun elsx:get-window-plist-by-name (name)
  (plist-get (cdr elsx:current-window-plist) name))


(defun elsx:pop-to:get-window (name)
  (let ((pop-to
         (when elsx:current-window-plist
           (or (when name
                 (plist-get (elsx:get-window-plist-by-name name)
                            :pop-to))
               (plist-get (elsx:perspective:get
                           (car elsx:current-window-plist))
                          :pop-to)))))
    (when pop-to
      (plist-get (plist-get (cdr elsx:current-window-plist) pop-to)
                 :window))))

(defun elsx:get-window-properties (&optional win)
  (let ((win   (selected-window))
        (rest   elsx:current-window-plist)
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
(defun elsx:display-buffer-function (buffer &optional other-window)
  (let* ((props  (elsx:get-window-properties))
         (name   (plist-get props :name))
         (pop-to (elsx:pop-to:get-window name)))
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
;;(setq display-buffer-function 'elsx:display-buffer-function)
(defadvice pop-to-buffer (around elsx:ad first
                                 (buffer-or-name
                                  &optional other-window norecord)
                                 activate)
  (let ((win (elsx:display-buffer-function buffer-or-name other-window)))
    (if win
        (progn (select-window win)
               (switch-to-buffer buffer-or-name))
      ad-do-it)))

;;(ad-disable-advice 'pop-to-buffer 'around 'elsx:window-el-advices)


(defadvice select-window (around elsx:ad last
                                 (window &optional norecord)
                                 activate)
  (let* ((R       ad-do-it)
         (plist   (elsx:get-window-properties))
         (onfocus (plist-get plist :onfocus)))
    (when onfocus (funcall onfocus))
    R))


;;(completing-read "which perspective? " elsx:perspective-alist nil t)

(defconst elsx:next-perspective-name nil)

(defun elsx:create (perspective-name)
  (interactive (list (intern (completing-read "which perspective? "
                                              elsx:perspective-alist nil t))))
  (setq elsx:next-perspective-name perspective-name)
  (elscreen-create))

(defun elsx:after-goto ()
  (let* ((screen  (elscreen-get-current-screen))
         (windows (gethash screen elsx:initialized-flags)))
    (unless windows
      (let ((scheme (or elsx:next-perspective-name
                        (plist-get elsx:perspective-setting
                                   (elscreen-get-current-screen))
                        'default)))
        (setq windows (elsx:init   scheme))
        (elsx:switch scheme))
      (puthash screen windows elsx:initialized-flags))
    (setq elsx:next-perspective-name nil)
    (setq elsx:current-window-plist windows)))

(add-hook 'elscreen-goto-hook 'elsx:after-goto)

(defadvice elscreen-kill (around
                          elsx:elscreen-advices
                          activate)
  (let ((screen (elscreen-get-current-screen)))
    (puthash screen nil elsx:initialized-flags))
  ad-do-it)

(defun elsx:modify-frame-color ()
  (elsx:switch (or (plist-get elsx:perspective-setting
                              (elscreen-get-current-screen))
                   'default)))
(add-hook 'elscreen-screen-update-hook 'elsx:modify-frame-color)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun elsx:set-environment (setting env)
  (setq elsx:perspective-setting setting)
  (setq elsx:perspective-alist   env))


(provide 'elsx)
;;; elsx.el ends here
