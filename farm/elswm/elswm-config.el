;;; elswm-config.el --- 

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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-config
;;;

(defvar elswm-config-objects (make-hash-table :test 'equal))
(defvar elswm:config-directory-initial-contents '("env"))
(defconst elswm:next-layout-name nil)

(defun elswm-config-object:new (directory &optional force-create)
  (if (file-exists-p directory)
    (progn (unless (file-directory-p directory)
             (error "%S is not a directory." directory)))
    (if (or force-create
            (yes-or-no-p (format "%S is not exists. Do you want to create it? "
                                 directory)))
        (make-directory directory)
      (error "directory %S is not exists.")))
  (unless (file-readable-p directory)
    (error "%S is not readable." directory))

  (dolist (sub elswm:config-directory-initial-contents)
    (let ((subdir (expand-file-name sub directory)))
      (unless (file-exists-p subdir)
        (make-directory subdir))))

  (let ((self (vector 'elswm-config-object
                      (list :directory directory
                            :children (make-hash-table :test 'equal)))))
    self))

(defun elswm-config-object-p (obj)
  (and (vectorp obj)
       (eq 'elswm-config-object (aref obj 0))))

(defun elswm-config (config &optional force-create)
  (cond ((elswm-config-object-p config) config)
        ((stringp config)
         (or (gethash config elswm-config-objects)
             (let ((obj (elswm-config-object:new config force-create)))
               (puthash config obj elswm-config-objects)
               obj)))
        (t (error "Illegal config specifier."))))

(defun elswm-config:directory (&optional config)
  (plist-get (aref (elswm-config config) 1) :directory))

(defun elswm-config:get-env (name &optional config force-create)
  (let* ((attrs (aref (elswm-config config) 1))
         (ht    (plist-get attrs :children))
         (dir   (plist-get attrs :directory)))
    (or (gethash name ht)
        (let ((env (elswm-env name
                              (expand-file-name (format "env/%s" name) dir)
                              force-create)))
          (puthash name env ht)
          env))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-env
;;;

(defvar elswm-env-objects (make-hash-table :test 'equal))
(defvar elswm-env-initialize-files '("env.el"
                                     "init.el"))

(defun elswm-env-object:new (name directory &optional force-create)
  (let ((self (vector 'elswm-env-object (list :name name :directory directory))))
    (unless (file-exists-p directory)
      (if (or force-create
              (yes-or-no-p
               (format "environment directory %s is not exists. create? "
                       directory)))
          (make-directory directory)
        (error "abort")))

    (unless (file-readable-p directory)
      (error "environment directory %s is not readable." directory))

    (unless (file-directory-p directory)
      (error "%s is not directory." directory))
    (elswm-env:init self)
    self))

(defun elswm-env:init (env)
  (dolist (file elswm-env-initialize-files)
    (let ((init-file (expand-file-name file (elswm-env:directory env))))
      (when (file-readable-p init-file)
        (load-file init-file)))))

(defun elswm-env-object-p (obj)
  (and (vectorp obj)
       (eq 'elswm-env-object (aref obj 0))))

(defun elswm-env (&optional env config-or-dir force-create)
  (or (cond ((elswm-env-object-p env) env)
            ((symbolp env)
             (elswm-env (symbol-name env) config-or-dir force-create))
            ((stringp env)
             (cond ((elswm-config-object-p config-or-dir)
                    (elswm-config:get-env env config-or-dir))
                   ((stringp config-or-dir)
                    (or (gethash config-or-dir elswm-env-objects)
                    (elswm-env-object:new env config-or-dir force-create))))))
      (error "malformed elswm-env specifier: %S %S"
             env config-or-dir)))

(defun elswm-env:name (&optional env c/d)
  (plist-get (aref (elswm-env env c/d) 1) :name))

(defun elswm-env:directory (&optional env c/d)
  (plist-get (aref (elswm-env env c/d) 1) :directory))

(defun elswm-env:layout-alist (&optional env c/d)
  (let* ((self (elswm-env env c/d))
         (dir  (elswm-env:directory self)))
    (when dir
      (apply 'append
             (list (list 'empty))
             (mapcar (lambda (file)
                       (when (string-match "\\(.+?\\)\\.layout\\'" file)
                         (list (list (intern (match-string 1 file))))))
                     (directory-files dir))))))

(defun elswm-env::layout-file (name &optional env c/d)
  (let* ((self (elswm-env env c/d))
         (dir  (elswm-env:directory self)))
    (expand-file-name (format "%s.layout") dir)))

(defun elswm-env:get-layout (name &optional env c/d)
  (if (eq name 'empty)
      (list 'empty)
    (or (loop for layoutn in (list name 'default) do
              (let* ((dir     (elswm-env:directory env c/d))
                     (layoutf (expand-file-name (format "%s.layout" layoutn)
                                                dir)))
                (when (file-readable-p layoutf)
                  (with-temp-buffer
                    (insert-file-contents layoutf)
                    (condition-case nil
                        (return (cons name
                                      (read (buffer-substring-no-properties
                                             (point-min) (point-max)))))
                       (error
                        (message "Malformed layout file: %s" layoutf)
                        nil))))))
        (and (eq name 'default)
             (list name)))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; elswm-layout
;;;
(require 'elswm-layout-write)

(defun elswm-read-layout-name ()
  (let ((layout-name (car (elswm-screen:layout)))
        name)
    (while (null name)
      (setq name (read-string "layout name: "
                              (if (eq layout-name 'empty) ""
                                (symbol-name layout-name))))
      (when (equal name "empty") (setq name nil)))
    name))

(defun elswm-layout-file-name (name)
  (expand-file-name
   (format "env/%s/%s.layout"
           (elswm-frame:environment-name)
           name)
   elswm-directory))

(provide 'elswm-config)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; TEST
;;;

(elswm-test
 elswm-config 
 (let ((tmp1 (expand-file-name (make-temp-name temporary-file-directory)))
       (tmp2 (expand-file-name (make-temp-name temporary-file-directory)))
       (caught-error))
   (yatest "Directories are not exists."
           (not (or (file-exists-p tmp1)
                    (file-exists-p tmp2))))
   (condition-case err
       (let* ((a (elswm-config tmp1 t))
              (b (elswm-config tmp1 t))
              (c (elswm-config tmp2 t)))
         (yatest "predicate of config"
                 (elswm-config-object-p a))
         (yatest "Are directories created ?"
                 (and (file-exists-p tmp1)
                      (file-exists-p tmp2)))
         (yatest "Subdirs are created ?"
                 (and (file-exists-p (expand-file-name "env" tmp1))
                      (file-exists-p (expand-file-name "env" tmp2))))
         (yatest "Same directory specification makes same instance."
                 (eq a b))
         (yatest "Other directory specification makes otheer instance."
                 (not (eq a c)))
         (yatest::p (make-string 70 ?- ) : )
         (let* ((ax (elswm-config:get-env "x" a t)))
           (yatest "elswm-config:get-env"
                   (elswm-env-object-p ax)))
         (make-directory 
          (yatest::p "env y:"
                     (expand-file-name "env/y"  (elswm-env:directory a))))
         (let* ((env-el (expand-file-name
                         "env/y/env.el" (elswm-env:directory a)))
                (init-el (expand-file-name
                          "env/y/init.el" (elswm-env:directory a))))
           (yatest::p "env.el" env-el)
           (yatest::p "init.el" init-el)
           (with-temp-buffer
             (insert "(setq xxx 1)")
             (setq buffer-file-name env-el)
             (save-buffer))
           (with-temp-buffer
             (insert "(setq yyy 2)")
             (setq buffer-file-name init-el)
             (save-buffer))
           (let* ((xxx nil)
                  (yyy nil)
                  (ay (elswm-config:get-env "y" a) ))
             (yatest "elswm-config:get-env 2" (elswm-env-object-p ay))
             (yatest "env.el"  (eq xxx 1))
             (yatest "init.el" (eq yyy 2))
             (yatest "get same environment"
                     (eq ay (elswm-config:get-env "y" a)))
             (let ((layouts  '(aaa bbb ccc)))
               (dolist (l layouts)
                 (let ((layoutf (expand-file-name
                                 (format "%s.layout" l)
                                 (elswm-env:directory ay))))
                   (with-temp-buffer
                     (insert "-*-emacs-lisp-*-")
                     (setq buffer-file-name layoutf)
                     (save-buffer))))
               (let ((alist (elswm-env:layout-alist ay)))
                 (yatest::p "alist" alist)
                 (yatest "layout-alist"
                         (and (eq (yatest::p "length of alist" (length alist))
                                  (yatest::p "length of src"
                                             (1+ (length layouts))))
                              (not
                               (loop for l in (cons 'empty layouts)
                                     for a in alist do
                                     (unless (equal (yatest::p "l" l )
                                                    (car (yatest::p "a" a)))
                                         (return t)))))))))))
     (error (setq caught-error err)))
   (delete-directory tmp1 t)
   (delete-directory tmp2 t)
   (when caught-error (error "%S" caught-error))
   ))
;;(yatest::run 'elswm 'elswm-config)


;;; elswm-config.el ends here
