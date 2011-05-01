;;; elswm-mode.el --- 

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


;;;;
;;;; advices
;;;;

(require 'easy-mmode)

(defvar elswm-mode nil)

(defconst elswm:next-layout-name nil)

(defun elswm:display-buffer-function:default-window (buf)
  (let* ((windows (window-list))
         (member  (member (selected-window) windows)))
    (cond ((> (length member ) 1) (cadr member))
          ((> (length windows) 1) (car windows))
          (t (split-window)))))

(defun elswm:display-buffer-function (buffer &optional other-window)
  (let ((win 
         (let ((buf (if (bufferp buffer) buffer (get-buffer buffer))))
           (unless (buffer-live-p buf)
             (error "illegal buffer: %s" buffer))
           (or (and (not other-window)
                    (loop for win in (window-list nil) do
                          (when (eq buf (window-buffer win))(return win))))
               (elswm-window:display-buffer-emacs-window buf)
               (elswm:display-buffer-function:default-window buf)))))
    (set-window-buffer win buffer)
    win))

(defun elswm-ad:setup ()

  (defadvice elscreen-clone (around elswm:ad activate)
    (let ((orig (elswm-screen))
          result)
      (let ((elswm-mode nil))
        (setq result
              ad-do-it))
      (let ((clone (elswm-screen:clone 
                    (elscreen-get-current-screen)
                    orig)))
        result)))

  (defadvice elscreen-kill (before elswm:ad activate)
    (elswm-elshook:previous-kill))

  (dolist (func elswm-ad:select-window-functions)
    (eval `(progn (defadvice ,func (after  elswm:ad activate)
                    (elswm-window:onfocus))))))

(defun elswm-ad:deactivate () (ad-deactivate-regexp "elswm.*"))

(defun elswm-ad:activate   () (ad-activate-regexp   "elswm.*"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-elshook
;;;


(defun elswm-elshook:after-goto ()
  (when elswm-mode 
    (when (not (get 'elswm-elshook:after-goto 'elswm:lock))
      (put 'elswm-elshook:after-goto 'elswm:lock t)
      (put 'elswm-window:onfocus 'elswm:lock t)
      (elswm-screen:initialize)
      (put 'elswm-window:onfocus 'elswm:lock nil)
      (elswm-window:onfocus)
      (put 'elswm-elshook:after-goto 'elswm:lock nil))))

(defun elswm-elshook:modify-frame-color ()
  (when elswm-mode  (elswm-screen:switch-colors)))

(defun elswm-elshook:setup ()
  (add-hook 'elscreen-goto-hook
            'elswm-elshook:after-goto)
  (add-hook 'elscreen-screen-update-hook
            'elswm-elshook:modify-frame-color))

(defun elswm-elshook:deactivate ()
  (remove-hook 'elscreen-goto-hook
               'elswm-elshook:after-goto)
  (remove-hook 'elscreen-screen-update-hook
               'elswm-elshook:modify-frame-color))

(defun elswm-elshook:previous-kill ()
  (let ((screen (elscreen-get-current-screen)))
    (elswm-screen:kill screen)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun elswm-mode:redefine ()
  (define-minor-mode elswm-mode
    "elswm"
    :lighter elswm-mode-lighter
    :global  t
    :group   'elswm
    (if elswm-mode
        (progn 
          (setq display-buffer-function 'elswm:display-buffer-function)
          (elswm-elshook:setup)
          (elswm-ad:setup)
          (elswm-elshook:after-goto))
      (progn
        (setq display-buffer-function nil)
        (elswm-ad:deactivate)
        (elswm-elshook:deactivate)))))
(elswm-mode:redefine)

(defalias 'global-elswm-mode 'elswm-mode)


(provide 'elswm-mode)
;;; elswm-mode.el ends here
