;;; rc-menu.el --- 

;; Copyright (C) 2010  

;; Author:  <lieutar@TREEFROG>
;; Keywords: 

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; 

;;; Code:


(require 'cl)

(defconst rc-menu:confirm:buffer nil)

(defconst rc-menu:confirm:timer          nil)
(defconst rc-menu:confirm:default-action (lambda ()))
(defconst rc-menu:confirm:cancel-action  (lambda ()))


(defsubst rc-menu:confirm:cancel-timer ()
  (when rc-menu:confirm:timer
    (cancel-timer rc-menu:confirm:timer)))

(defun rc-menu:confirm-mode:y ()
  (interactive)
  (rc-menu:confirm:cancel-timer)
  (kill-buffer rc-menu:confirm:buffer)
  (funcall rc-menu:confirm:default-action))

(defun rc-menu:confirm-mode:n ()
  (interactive)
  (rc-menu:confirm:cancel-timer)
  (kill-buffer rc-menu:confirm:buffer))

(defconst rc-menu:confirm-mode-map
  (let ((km (make-sparse-keymap)))
    (define-key km (kbd "n") 'rc-menu:confirm-mode:n)
    (define-key km (kbd "y") 'rc-menu:confirm-mode:y)
    km))

(define-derived-mode rc-menu:confirm-mode
  fundamental-mode "rc-menu:confirm-mode"
  (setq buffer-read-only t))


(defun rc-menu:confirm (&rest opts)
  (let* ((timeout        (plist-get     opts :timeout ))
         (default-action (or (plist-get opts :default-action )
                             (lambda ())))
         (cancel-action  (or (plist-get opts :cancel-action )
                             (lambda ())))
         (message
          (or (plist-get :message opts)
              (concat
               (format  "Hello %s !!" user-login-name) "\n"
               "Do you want to build your usual environment? (Y / n) :")))

         (message-lines (with-temp-buffer
                          (insert message)
                          (line-number-at-pos (point))))

         (buf     (get-buffer-create "*setup-my-working-environment*"))
         (height  (cdr (assq 'height (frame-parameters (selected-frame))))))

    (setq rc-menu:confirm:buffer buf)
    (switch-to-buffer buf)

    (loop for c from 1 to (- (/ (- height message-lines) 2) 2) do
          (insert "\n"))
    (insert message)
    (rc-menu:confirm-mode)

    (setq rc-menu:confirm:default-action default-action)
    (setq rc-menu:confirm:cancel-action  cancel-action)

    (when timeout
      (setq rc-menu:confirm:timer
            (run-at-time (format "%d sec" timeout) nil 
                         (lambda ()
                           (message "rc-menu ... timeout")
                           (rc-menu:confirm-mode:y)))))))


(provide 'rc-menu)
;;; rc-menu.el ends here
