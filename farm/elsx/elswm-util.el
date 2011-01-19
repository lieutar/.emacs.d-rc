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

(defun elswm-util:ws-vertically (size window op)
  (let* ((window (cond ((null    window) (selected-window))
                       ((windowp window) window)
                       ((symbolp window) 
                        (let ((wplist (elswm-window:attributes window)))
                          (unless wplist (error "undefined window: %s" window))
                          (plist-get wplist :window)))))
         (size   (if (> size 0) size (+ size (frame-parameter
                                              (window-frame window) 'height))))
        (height (window-height window)))
    (when (funcall op height size)
      (let ((back-to (selected-window)))
        (select-window window)
        (enlarge-window (- size height))
        (select-window back-to)))))

(defun elswm-util:widen-vertically (size &optional window)
  (elswm-util:ws-vertically size window '<))

(defun elswm-util:shlink-vertically (size &optional window)
  (elswm-util:ws-vertically size window '>))

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
