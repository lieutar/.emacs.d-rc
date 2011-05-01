;;; elswm-commands.el --- 

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

(require 'elswm-mode)
(require 'elswm-window-select)

(defun elswm-layout-save ( name &optional frame )
  (interactive (list (elswm-read-layout-name)))
  (let ((layout-file (elswm-layout-file-name name)))
    (with-temp-buffer
      (elswm-layout-write frame)
      (setq buffer-file-name layout-file)
      (save-buffer))
    layout-file))

(defun elswm-layout-edit (name)
  (interactive (list (elswm-read-layout-name)))
  (let ((layout-file (elswm-layout-file-name name)))
    (find-file layout-file)))

(defun elswm-set-window-pop-to ()
  (interactive)
  (elswm-window-select
   (lambda (win)
     (elswm-window:modify-attributes
      (list :pop-to (plist-get
                     (elswm-window:attributes win) :name))))))

(defun elswm-set-default-pop-to ()
  (interactive)
  (elswm-window-select
   (lambda (win)
     (elswm-screen:modify-attributes
      (list :pop-to (plist-get
                     (elswm-window:attributes win) :name))))))

(defun elswm-create (layout-name)
  (interactive (list (elswm-frame:read-layout-name)))
  (setq elswm:next-layout-name layout-name)
  (elscreen-create))

(defalias 'elswm:create 'elswm-create)

(defun elswm-force-onfocus ()
  (interactive)
  (elswm-window:onfocus))

(defun elswm-initialize-window-interactive (cmd)
  (interactive (list (read-command "M-x: ")))
  (plist-put (elswm-window:attributes) :init cmd)
  (call-interactively cmd))


(provide 'elswm-commands)
;;; elswm-commands.el ends here
