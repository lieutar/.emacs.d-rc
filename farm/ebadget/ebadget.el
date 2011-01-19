;;; ebadget.el --- emacs buffer gadget

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

(defun ebadget:set-timer (name timer)
  (puthash name timer ebadget:timers))

(defun ebadget:stop-timer (name)
  (let ((timer (gethash name ebadget:timers)))
    (when timer
      (cancel-timer timer)
      (ebadget:set-timer name nil))))

(defun ebadget (&rest opts)
  (let* ((name            (or (plist-get opts :name)
                              (error "property :name is required.")))
         (buffer-name    (format "*%s*" name))
         (init-command   (or (plist-get opts :init)
                             (lambda ())))
         (update-command (or (plist-get opts :update)
                             (error "property :update is required.")))
         (interval       (or (plist-get opts :interval) 1)))

    (if (get-buffer buffer-name)

        (switch-to-buffer buffer-name)

      (let ((buf (get-buffer-create buffer-name)))
        (switch-to-buffer buf)
        (funcall init-command)
        (ebadget:set-timer
         name
         (run-at-time
          "0 sec"
          interval
          `(lambda ()
             (if (buffer-live-p ,buf)
                 (progn
                   (save-excursion
                     (set-buffer ,buf)
                     (setq buffer-read-only t)
                     (let ((buffer-read-only nil))
                       (funcall ',update-command))
                     )
                   )
               (progn (ebadget:stop-timer ,name))))))))))

(provide 'ebadget)
;;; ebadget.el ends here
