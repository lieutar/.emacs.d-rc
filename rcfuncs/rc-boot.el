;;; rc-boot.el --- 

;; Copyright (C) 2010  lieutar

;; Author: lieutar <lieutar@kael-laptop>
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

(defvar rc-directory    "~/.emacs.d/rc")

(defvar rc-subdirs-list '(

                          "rcfuncs"
                          "base"
                          "ext"
                          "funcs"
                          "projects"
                          "last"

                          ))

(defvar rc-emacsen (mapconcat
                    'identity
                    (list 
                     (cond ((featurep 'meadow) "meadow")
                           (t "fsf"))
                     (cdr (or (assq system-type
                                    '((windows-nt . "nt")
                                      (cygwin     . "cygwin")))
                              (cons nil "unicom")))
                     (number-to-string emacs-major-version))
                    "-"))

(defun rc-file-loadable-p (file)
  (and (string-match
        "\\(\\(\\.[^./\\\\]+\\)*\\)\\.el\\'"
        file)
       (or (not (match-string 2 file))
           (let ((emacsens (split-string (substring (match-string 1 file)
                                                    1)
                                         "\\.")))
             (and (member rc-emacsen emacsens)
                  t)))))





(defun rc-boot-file-list ()
  (apply
   'append
   (mapcar
    (lambda (rc-dir)
      (let ((dir (expand-file-name
                  (format "%s/%s" rc-directory rc-dir))))
        (if (file-exists-p dir)
            (apply
             'append
             (mapcar
              (lambda (file)
                (let ((boot-file (format "%s/%s" dir file)))
                  (if (rc-file-loadable-p boot-file)
                      (list boot-file))
                  ))
              (directory-files dir)))
          )))
    rc-subdirs-list))
  )

(defun rc-time< (a b)
  (or (< (car a) (car b))
      (and (= (car a)
              (car b))
           (< (car (cdr a))
              (car (cdr b))))))

(defvar rc-boot-loaded-file-alist ())
(defun rc-boot-is-file-new-p (file)
  (let ((slot (assoc file rc-boot-loaded-file-alist)))
    (if slot
        (rc-time< 
         (cdr slot)
         (nth 5 (file-attributes file)))
      t)))

(defun rc-boot ()
  (interactive)
  (let ((now (current-time)))
    (dolist (file (rc-boot-file-list))
      (if (rc-boot-is-file-new-p file)
          (condition-case e 
              (progn
                (load file)
                (setq rc-boot-loaded-file-alist
                      (cons (cons file now)
                            rc-boot-loaded-file-alist)))
            (error  (message
                     (format "%S\n... caught when loading %s\n\n" e file))
                    ))))))

(defvar rc-boot nil)
(unless rc-boot
  (setq rc-boot t)
  (rc-boot))

;;; boot.el ends here
