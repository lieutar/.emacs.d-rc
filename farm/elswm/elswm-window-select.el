;;; elswm-window-select.el --- 

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

(require 'easy-mmode)

(defconst elswm-window-select:continuation nil)
(defconst elswm-window-select:back-to nil)

(defun elswm-window-select-cancel ()
  (interactive)
  (elswm-window-select-mode -1)
  (when elswm-window-select:back-to
    (select-window elswm-window-select:back-to)
    (elswm-window:onfocus))
  (setq elswm-window-select:back-to      nil
        elswm-window-select:continuation nil))

(defun elswm-window-select-done ()
  (interactive)
  (elswm-window-select-mode -1)
  (let ((win (selected-window))
        (cont (or elswm-window-select:continuation
                  (lambda (win) (message "%S" win)))))
    (elswm-window-select-cancel)
    (funcall cont win)))

(defconst elswm-window-select-mode-map
  (let ((km '(keymap (t . undefined))))
    (when (locate-library "windmove")
      (require 'windmove)
      (define-key km [?\C-b] 'windmove-left)
      (define-key km [?\C-n] 'windmove-down)
      (define-key km [?\C-p] 'windmove-up)
      (define-key km [?\C-f] 'windmove-right)
      (define-key km [?h]    'windmove-left)
      (define-key km [?j]    'windmove-down)
      (define-key km [?k]    'windmove-up)
      (define-key km [?l]    'windmove-right)
      (define-key km [left]  'windmove-left)
      (define-key km [right] 'windmove-right)
      (define-key km [up]    'windmove-up)
      (define-key km [down]  'windmove-down))
    (define-key km [tab]     'other-window)
    (define-key km [?q]       'elswm-window-select-cancel)
    (define-key km (kbd "<SPC>") 'elswm-window-select-done)
    km))

(define-minor-mode elswm-window-select-mode
  "elswm window selct"
  :global t
  :init-value nil
  :keymap elswm-window-select-mode-map
  :lighter " elswm window select mode"
  (if elswm-window-select-mode
      (progn
        (message "choose window by : q - quit / [SPC] - done")
        )
    (progn
      )))

(defun elswm-window-select (continuation)
  (setq elswm-window-select:back-to  (selected-window))
  (setq elswm-window-select:continuation continuation)
  (elswm-window-select-mode 1))

(provide 'elswm-window-select)
;;; elswm-window-select.el ends here
