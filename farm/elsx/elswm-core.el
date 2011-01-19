;;; elswm-core.el --- 

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-env
;;;

(defun elswm-env-object:new (name directory)
  (let ((self (vector 'elswm-env-object (list :name name :directory directory))))
    self))

(defun elswm-env-object-p (obj)
  (and (vectorp obj)
       (eq 'elswm-env-object (aref obj 0))))

(defun elswm-env:name         (self) (plist-get (aref self 1) :name))
(defun elswm-env:directory    (self) (plist-get (aref self 1) :directory))
(defun elswm-env:init         (self)
  (let ((self (elswm-frame frame))
        (env-dir (expand-file-name (format "env/%s" env-name)
                                   elswm-directory)))

    (unless (file-exists-p env-dir)
      (if (y-or-n-p
           (format "environment directory %s is not exists. create? "
                   env-dir))
          (make-directory env-dir)
        (error "abort")))

    (unless (file-readable-p env-dir)
      (error "environment directory %s is not readable." env-dir))

    (unless (file-directory-p env-dir)
      (error "%s is not directory." env-dir))

    (plist-put (aref self 1) :environment-name env-name)

    (dolist (file '("env.el"
                    "init.el"))
      (let ((init-file (expand-file-name file env-dir)))
        (when (file-readable-p init-file)
          (load-file init-file))))
(defun elswm-env:layout-alist (self))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-layout
;;;
(require 'elswm-layout-write)

(defun elswm-read-layout-name ()
  (let ((layout-name (car (elswm-screen:layout)))
        name)
    (while (null name)
      (setq name (read-string "layout name: "
                              (if (eq layout-name 'empty) ""
                                (symbol-name layout-name))))
      (when (equal name "empty") (setq name nil)))
    name))

(defun elswm-layout-file-name (name)
  (expand-file-name
   (format "env/%s/%s.layout"
           (elswm-frame:environment-name)
           name)
   elswm-directory))




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-frame
;;;


(defun elswm-frame-object:new (frame)
  (let ((self (vector
               'elswm-frame-object
               (list :frame (or frame (selected-frame))))))
    (modify-frame-parameters frame `((elswm . ,self)))
    self))

(defun elswm-frame-object-p (obj)
  (and (vectorp obj)
       (eq 'elswm-frame-object (aref obj 0))))

(defun elswm-frame (&optional frame)
  (cdr (or (assq 'elswm (frame-parameters frame))
           (cons nil (elswm-frame-object:new frame)))))


(defun elswm-frame:environment-name (&optional frame)
  (let ((self (elswm-frame frame)))
    (plist-get (aref self 1) :environment-name)))

(defun elswm-frame:set-environment-name (env-name &optional frame)
  (let ((self (elswm-frame frame))
        (env-dir (expand-file-name (format "env/%s" env-name)
                                   elswm-directory)))

    (unless (file-exists-p env-dir)
      (if (y-or-n-p
           (format "environment directory %s is not exists. create? "
                   env-dir))
          (make-directory env-dir)
        (error "abort")))

    (unless (file-readable-p env-dir)
      (error "environment directory %s is not readable." env-dir))

    (unless (file-directory-p env-dir)
      (error "%s is not directory." env-dir))

    (plist-put (aref self 1) :environment-name env-name)

    (dolist (file '("env.el"
                    "init.el"))
      (let ((init-file (expand-file-name file env-dir)))
        (when (file-readable-p init-file)
          (load-file init-file))))

    (when nil
      (condition-case err
          (let ((layouts (plist-get (aref self 1) :initial-layouts))
                (screen-list (elscreen-get-screen-list)))
            (loop for screen from 0 to (length layouts)
                  for layout in layouts do
                  (progn
                    (message "%s %s" screen layout)
                    (if (memq screen screen-list)
                        (elscreen-goto screen)
                      (elscreen-create))
                    (message "OK!"))))
        (error (message "%S" err))))))


(defun elswm-frame:set-initial-layouts (layouts &optional frame)
  (let ((self (elswm-frame frame)))
    (plist-put (aref self 1) :initial-layouts layouts)))


(defun elswm-frame:get-environment-directory (&optional frame)
  (let* ((self (elswm-frame frame))
         (envn (elswm-frame:environment-name)))
    (when envn
      (expand-file-name (format "env/%s" envn)
                        elswm-directory))))


(defun elswm-frame:layout-alist (&optional frame)
  (let ((dir (elswm-frame:get-environment-directory frame)))
    (when dir
      (apply 'append
             (list (list "empty"))
             (mapcar (lambda (file)
                       (when (string-match "\\(.+?\\)\\.layout\\'" file)
                         (list (list (intern (match-string 1 file))))))
                     (directory-files dir))))))

(defun elswm-frame:get-layout (name &optional frame)
  (if (eq name 'empty)
      (list 'empty)
    (or (loop for layoutn in (list name 'default) do
              (let* ((dir     (elswm-frame:get-environment-directory frame))
                     (layoutf (expand-file-name (format "%s.layout" layoutn)
                                                dir)))
                (when (file-readable-p layoutf)
                  (with-temp-buffer
                    (insert-file-contents layoutf)
                    (condition-case nil
                        (return (cons name
                                      (read (buffer-substring-no-properties
                                             (point-min) (point-max)))))
                       (error
                        (message "Malformed layout file: %s" layoutf)
                        nil))))))
        (and (eq name 'default)
             (list name)))))

(defun elswm-frame:read-layout-name (&optional frame)
  (intern
   (completing-read "which layout? "
                    (elswm-frame:layout-alist frame)
                    nil t)))


(defun elswm-frame:get-screen-layout (&optional screen frame)
  (let* ((self    (elswm-frame frame))
         (plist   (aref self 1))
         (layouts (plist-get plist :initial-layouts)))
    (elswm-frame:get-layout
     (or (nth (or screen
                  (elscreen-get-current-screen)) layouts) 'default) frame)))

(defun elswm-frame:get-screen-dic (&optional frame)
  (let* ((self   (elswm-frame frame))
         (dic    (plist-get (aref self 1) :screen-dic)))
    (unless dic
      (setq dic (make-hash-table :test 'eq))
      (plist-put (aref self 1) :screen-dic dic))
    dic))

(defun elswm-frame:drop-screen (screen &optional frame)
  (puthash screen nil (elswm-frame:get-screen-dic frame)))

(defun elswm-frame:register-screen (screen obj &optional frame)
  (puthash screen obj (elswm-frame:get-screen-dic frame)))

(defun elswm-frame:get-screen (screen &optional frame)
  (gethash screen (elswm-frame:get-screen-dic frame)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-screen
;;;
(require 'elswm-screen-init)

(defun elswm-screen-object:new (&optional screen  frame)
  (let ((self (vector 'elswm-screen-object
                      (list
                       :frame       (elswm-frame frame)
                       :number      screen
                       :initialized nil
                       :params      (make-hash-table :test 'eq)
                       :layout          nil
                       :layout-instance nil
                       :windows         nil))))
    (elswm-frame:register-screen (or screen
                                    (elscreen-get-current-screen))
                                self frame)
    self))


(defun elswm-screen (&optional screen frame)
  (if (elswm-screen-object-p screen) screen
    (let* ((screen (or screen (elscreen-get-current-screen))))
      (or (elswm-frame:get-screen screen frame)
          (elswm-screen-object:new screen frame)))))

(defun elswm-screen-object-p (obj)
  (and (vectorp obj)
       (eq 'elswm-screen-object (aref obj 0))))

(defun elswm-screen:clone (new-num &optional screen frame)
  (let* ((orig  (elswm-screen screen frame))
         (plist (copy-list (aref orig 1)))
         (clone       (vector 'elswm-screen-object plist)))
    (plist-put plist :screen  screen)
    (elswm-frame:register-screen new-num clone frame)
    clone))

(defun elswm-screen:put-param (prop value &optional screen frame)
  (puthash prop value (plist-get (aref (elswm-screen screen frame) 1) :params)))

(defun elswm-screen:get-param (prop &optional screen frame)
  (gethash prop (plist-get (aref (elswm-screen screen frame) 1) :params)))

(defun elswm-screen:params-alist (&optional screen frame)
  (let ((R ()))
    (maphash
     (lambda (key val)
       (setq R (cons key (cons val R))))
     (plist-get (aref (elswm-screen screen frame) 1) :params))
    R))

(defun elswm-screen:number (&optional screen frame)
  (plist-get (aref (elswm-screen screen frame) 1) :number))

(defun elswm-screen:frame (&optional screen frame)
  (plist-get (aref (elswm-screen screen frame) 1) :frame))

(defun elswm-screen:layout (&optional screen frame)
  (plist-get (aref (elswm-screen screen frame) 1) :layout))

(defun elswm-screen:color-scheme (&optional screen frame)
  (or (plist-get (cdr (elswm-screen:layout screen)) :color)
      elswm:default-color-scheme))

(defun elswm-screen:switch-colors (&optional screen frame)
  (let* ((color    (elswm-screen:color-scheme screen)))
    (modify-frame-parameters
     nil
     `((foreground-color . ,(car color))
       (background-color . ,(cdr color))))))

(defun elswm-screen:get-pop-to (&optional screen frame)
  (plist-get (cdr (elswm-screen:layout screen)) :pop-to))

(defun elswm-screen:kill (&optional screen frame)
  (elswm-frame:drop-screen (or screen (elscreen-get-current-screen))))


(defun elswm-screen:initialized (&optional screen frame)
  (plist-get (aref (elswm-screen screen frame) 1) :initialized))

(defun elswm-screen:initialize (&optional screen frame)
  (unless (elswm-screen:initialized screen)
    (let* ((scheme (if elswm:next-layout-name
                       (elswm-frame:get-layout elswm:next-layout-name)
                     (elswm-frame:get-screen-layout screen)))
           (attrs  (aref (elswm-screen screen frame) 1)))
      (plist-put attrs :layout     scheme)
      (elswm-screen-init scheme)
      (plist-put attrs :initialized t)
      (elswm-screen:switch-colors screen frame)))
  (setq elswm:next-layout-name      nil))

(defun elswm-screen:modify-attributes (new-attrs &optional screen frame)
  (let* ((attrs (cdr (elswm-frame:get-screen-layout screen frame))))
    (while new-attrs
      (plist-put attrs (car new-attrs) (cadr new-attrs))
      (setq new-attrs (ccdr new-attrs)))))

(defun elswm-screen:windows (&optional screen frame)
  (plist-get (aref (elswm-screen screen frame) 1) :windows))

(defun elswm-screen:set-windows (windows &optional screen frame)
  (plist-put (aref (elswm-screen screen frame) 1) :windows windows))

(defun elswm-screen:get-window (name &optional screen frame)
  (plist-get (plist-get (aref (elswm-screen screen frame) 1) :windows) name))

(defun elswm-screen:register-window (name win &optional screen frame)
  (let ((attrs  (aref (elswm-screen screen frame) 1)))
    (plist-put attrs :windows
               (cons name (cons win (plist-get attrs :windows))))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;; elswm-window
;;;;
(defun elswm-window-object:new (window attrs &optional screen frame)
  (let ((self (vector 'elswm-window-object
                      (cons :window (cons (or window  (selected-window))attrs))))
        (name (plist-get attrs :name)))
    (set-window-parameter window 'elswm self)
    (when name (elswm-screen:register-window name self screen frame))
    self))

(defun elswm-window-p (obj)
  (and (vectorp obj)
       (>= (length obj) 2)
       (eq 'elswm-window-object (aref obj 0))))

(defun elswm-window (&optional window screen frame)
  (cond ((elswm-window-p window) window)
        ((or (null          window)
             (windowp       window))
         (window-parameter window 'elswm))
        ((symbolp       window)
         (elswm-screen:get-window window screen frame))))

(defun elswm-window:attributes (&optional window screen frame)
  (let ((obj (elswm-window window screen frame)))
    (when obj (aref obj  1))))

(defun elswm-window:pop-to (&optional window screen frame)
  (or (plist-get (elswm-window:attributes window screen frame):pop-to)
      (elswm-screen:get-pop-to screen frame)))

(defun elswm-window:emacs-window (&optional window screen frame)
  (plist-get (elswm-window:attributes window screen frame) :window))

(defun elswm-window:onfocus (&optional window screen frame)
  (unless (get 'elswm-window:onfocus 'elswm:lock)
    (let* ((plist   (elswm-window:attributes window screen frame))
           (onfocus (plist-get plist :onfocus)))
      (when onfocus (funcall onfocus)))))

(defun elswm-window:modify-attributes (attrs &optional window screen frame)
  (while (attrs)
    (plist-put (elswm-window:attributes window screen frame)
               (car attrs) (cadr attrs))
    (setq attrs cddr attrs)))


(provide 'elswm-core)
;;; elswm-core.el ends here
