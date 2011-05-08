;;; elswm-util.el --- 

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

(defun elswm-util:ws-vh (size window op dir)
  (let*
      (;; props
       (syms       (if (eq dir 'vertical)
                       '(height nil window-height)
                     '(width t window-width)))
       (size-prop       (car   syms))
       (horizontally    (cadr  syms))
       (get-window-size (caddr syms))

       ;;  windows
       (back-to (selected-window))
       (win     (cond ((null    window) (selected-window))
                      ((windowp window) window)
                      ((symbolp window) 
                       (let ((wplist (elswm-window:attributes window)))
                         (unless wplist
                           (error "undefined window: %s" window))
                         (plist-get wplist :window)))))

       ;; sizes
       (size   (if (> size 0)
                   size
                 (+ size (frame-parameter (window-frame win) size-prop))))
       ;;
       (window-size  (funcall get-window-size win)))


    (when (funcall op window-size size)
      (select-window win)
      (enlarge-window (- size window-size) horizontally)
      (select-window back-to))))


(defun elswm-util:widen-vertically (size &optional window)
  (elswm-util:ws-vh size window '< 'vertical))
(defun elswm-util:shlink-vertically (size &optional window)
  (elswm-util:ws-vh size window '> 'vertical))

(defun elswm-util:widen-horizontally (size &optional window)
  (elswm-util:ws-vh size window '< 'horizontal))
(defun elswm-util:shlink-horizontally (size &optional window)
  (elswm-util:ws-vh size window '> 'horizontal))


(defun elswm-util:3cols:init-with-eshell (dir)
  (switch-to-buffer
   (save-window-excursion
     (let ((buf (eshell t)))
       (set-buffer buf)
       (insert "cd " dir)
       (call-interactively 'eshell-send-input)
       (let ((inhibit-read-only t))
         (delete-region (point-min)(point-max)))
       (call-interactively 'eshell-send-input)
       buf))))

(provide 'elswm-util)
;;; elswm-util.el ends here
