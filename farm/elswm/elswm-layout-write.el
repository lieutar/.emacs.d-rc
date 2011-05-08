;;; elswm-layout-write.el --- 

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

(defun elswm-layout-write:win-details:init (window)
  (with-current-buffer (window-buffer window)
    (cond
     (buffer-file-name
      `(lambda ()
         (find-file ,buffer-file-name)
         (goto-char ,(point))))
     ((eq major-mode 'dired-mode)
      `(lambda ()
         (dired ,dired-directory)))
     ((member (buffer-name) elswm-layout-write-default-buffer-names)
      `(lambda ()
         (switch-to-buffer ,(buffer-name)))))))

(defun elswm-layout-write:win-details (window)
  (let ((plist (cdr (or (assq 'elswm (window-parameters window))
                        (list nil)))))
    (apply 'append
           (mapcar (lambda (slot)
                     (let ((kw  (car slot))
                           (fun (cadr slot)))
                       (list kw
                             (or (plist-get plist kw)
                                 (funcall fun window)))))
                   '((:init    elswm-layout-write:win-details:init)
                     (:onfocus (lambda (win) nil))
                     (:pop-to  (lambda (win) nil)))))))

(defun elswm-layout-write:wtree2composition (tree &optional vertically)
  (if (windowp tree)
      (progn
        (let ((edges (window-edges tree)))
          (append
           (list :name nil
                 :size (if vertically 
                           (- (nth 3 edges) (nth 1 edges))
                         (- (nth 2 edges) (nth 0 edges))))
           (elswm-layout-write:win-details tree))))
    (progn
      (let ((vertically (car  tree))
            (edges     (cadr tree))
            (children  (cddr tree))
            (i         0))
        (cons (list (if vertically '- '|)
                    :size (if vertically 
                              (- (nth 2 edges) (nth 0 edges))
                            (- (nth 3 edges) (nth 1 edges))))
              (mapcar
               (lambda (child)
                 (elswm-layout-write:wtree2composition
                  child vertically))
               children))))))

(defun elswm-layout-write:insert:item (item)
  (if (and (listp item)(functionp item))
      (let* ((col  (- (point) (save-excursion (beginning-of-line)(point))))
             (body (cddr item))
             (indent (make-string (+ 2 col) ? )))
        (insert "(lambda " (if (cadr item) (format "%S" item) "()") "\n")
        (while body
          (insert indent)
          (elswm-layout-write:insert:item (car body))
          (setq body (cdr body))
          (when body (insert "\n")))
        (insert ")"))
    (insert (format "%S" item))))

(defun elswm-layout-write:insert (conf indent)
  (insert indent "(")
  (let ((car (car conf)))
    (if (listp car)

        (progn (insert (format "(%s " (car car)))
               (let ((elems (cdr car)))
                 (while elems
                   (insert (format "%S "
                                   (car  elems)))
                   (elswm-layout-write:insert:item
                    (cadr elems))
                   (setq elems (cddr elems))
                   (when elems (insert "\n" indent "   "))))
               (insert ")\n")
               (let ((children (cdr conf)))
                 (while children
                   (elswm-layout-write:insert
                    (car children) (concat indent "  "))
                   (setq children (cdr children))
                   (when children (insert "\n")))))

      (progn
        (while conf
          (insert (format "%S " (car conf)))
          (elswm-layout-write:insert:item (cadr conf))
          (setq conf (cddr conf))
          (when conf (insert "\n" indent " "))))))
  (insert ")"))

(defun elswm-layout-write (&optional frame)
  (insert ";-*-emacs-lisp-*-\n")
  (insert "(\n")
  (insert " :composition\n")
  (elswm-layout-write:insert
   (elswm-layout-write:wtree2composition 
    (car (window-tree frame)))
   " ")
  (insert "\n)\n"))

  
(provide 'elswm-layout-write)
;;; elswm-layout-write.el ends here
