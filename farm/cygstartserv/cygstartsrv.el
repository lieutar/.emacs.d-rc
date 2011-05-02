;;; cygstartsrv.el --- 

;; Copyright (C) 2011  

;; Author:  <lieutar@colinux>
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

(defvar cygstartsrv/server-name "192.168.2.1")
(defvar cygstartsrv/server-port 8989)

(defvar cygstartsrv/buffer nil)
(defvar cygstartsrv/stream nil)

(defun cygstartsrv/get-process ()
  (unless (and (processp cygstartsrv/stream)
               (eq 'open (process-status cygstartsrv/stream)))
    (setq cygstartsrv/stream
          (open-network-stream
           " *cygstartsrv*"
           (if (buffer-live-p cygstartsrv/buffer)
               cygstartsrv/buffer
             (setq cygstartsrv/buffer (get-buffer-create " *cygstartsrv*")))
           cygstartsrv/server-name
           cygstartsrv/server-port)))
  cygstartsrv/stream)

(defun cygstartsrv/browse-url (url &optional new-window)
  (let ((proc (cygstartsrv/get-process)))
    (process-send-string proc (concat url "\n"))))

;;(cygstartsrv/browse-url "http://yahoo.co.jp")

(provide 'cygstartsrv)
;;; cygstartsrv.el ends here
