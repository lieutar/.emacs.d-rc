;; -*- coding: utf-8 -*-
(require 'cl)
(condition-case err
    (let ((fontspec-list '(("Consolas" "MS Gothic"))))
      (let ((fsgen
             (lambda (name
                      size
                      ascii-font
                      ja-font)
               (let ((XLFD-name  (format (concat "-outline-%s-normal-r"
                                                 "-normal-normal-%d"
                                                 "-*-*-*-*-*-iso8859-1")
                                         ascii-font
                                     size)))
                 (create-fontset-from-ascii-font XLFD-name
                                                 nil 
                                                 name)
                 (let ((fontset-name (concat "fontset-" name)))
                   (set-fontset-font fontset-name
                                     'japanese-jisx0208
                                     `(,ja-font . "jisx0208-sjis"))
                   (set-fontset-font fontset-name
                                     'katakana-jisx0201
                                     `(,ja-font . "jisx0201-katakana")))))))
        (dolist (spec fontset-list)
          (dolist (size '(7 8 9 10 11 12
                            14 16 18 20 24))
            (let* ((ascii   (car spec))
                   (ja-font (cadr spec))
                   (name    (replace-regexp-in-string
                             "[^a-z0-9A-Z_]" ""
                             (format "%s%s" ascii ja-font))))
              (funcall fsgen
                       name
                       size
                       ascii
                       ja-font)
              name)))))
  (error ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;あああああああああああああああああああああああああああああああああああああああ
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
;(insert(format"\n%S" (cdr (assoc 'font (frame-parameters (selected-frame))))))



(setq
 default-frame-alist
 (append 
  '((font   . "-*-*-normal-r-normal-normal-11-*-*-*-*-*-fontset-msgothic")
    (height . 82))
  default-frame-alist))





