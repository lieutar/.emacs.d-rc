;;; kael-project.el --- 

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
(defconst kael-project-alist)


(defun kael-project--parent-directory (path)
  (let ((dir (file-name-directory (expand-file-name path))))
    (replace-regexp-in-string
     "/\\'" ""
     dir)))


(when nil

  (make-event :name "")

  (make-task :name   ""
             :weight  0
             :depends ""
             :from    ""
             :to      )


)



(provide 'kael-project)
;;; kael-project.el ends here
