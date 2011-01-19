;;; elswm-screen-init.el --- 

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


(defun elswm-screen-init:init-leaf-window (composition)
  "Initialize buffer window.

  SEE ALSO: `elswm-screen-init:set-composition'.
"
  (let ((init (or (plist-get composition :init) (lambda ()))))
    (elswm-window-object:new (selected-window) composition)
    (funcall init)))


(defun elswm-screen-init:init-node-window (composition)
  "Splits windows by the `CONPOSITION' spec.

  SEE ALSO: `elswm-screen-init:set-composition'
"
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
        (when sizes   (split-window nil size (eq type '|)))
        (other-window 1)))
    (dolist (win (reverse windows))
      (select-window win)
      (elswm-screen-init:set-composition
       (nth index details))
      (setq index (1+ index)))))


(defun elswm-screen-init:set-composition (composition)
  "

The form of the `COMPOSITION' is following:

  Nested window:

   If the list starts with list, the list specifies nested window.
   The form of the list that is located by the specification as
   first element begins by symbol: '|' or '-'. 

   These symbols mean dividing align of child windows.
   '|' means horizontal dividing, and '-' means vertical dividing.

  Buffer window:

   If the list starts with keywords or

   :name    .... The name of the windwow.
   :onfocus .... Focus event handler.
   :init    .... Window initializer.
   :pop-to  .... The specification for `display-buffer'.

"
  (when composition
    (cond
     ((keywordp (car composition))
      (elswm-screen-init:init-leaf-window composition))
     ((listp    (car composition))
      (elswm-screen-init:init-node-window composition))
     (t (error "malformed specification")))))



(defun elswm-screen-init (scheme)
  ""
  (let* ((name        (car scheme))
         (plist       (cdr scheme))
         (preinit     (plist-get plist :init))
         (focus-to    (plist-get plist :focus))
         (composition (plist-get plist :composition)))
    (when preinit (funcall preinit))
    (delete-other-windows)
    (setq elswm:focused-window (selected-window))
    (elswm-screen-init:set-composition composition)
    (when focus-to
      (let ((win (elswm-window:emacs-window focus-to)))
        (when win (select-window win))))))


(provide 'elswm-screen-init)
;;; elswm-init.el ends here
