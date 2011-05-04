;;-*- coding: utf-8 -*-

(require 'ebadget)

(defvar ebadget:slogan:string "Set the `ebadget:slogan:string' variable!")

(make-face 'ebadget:slogan:face)
(set-face-attribute 'ebadget:slogan:face nil
;;                    :font          "DFPMaruGothic-Md"
                    :height        3.0
                    :weight        'normal
                    :inverse-video nil
                    :foreground    "#C33")

(defun ebadget:slogan:update ()
  (delete-region (point-min) (point-max))
  (setq cursor-type nil)
  (insert (propertize ebadget:slogan:string
                      'face 'ebadget:slogan:face)))

(defun ebadget:slogan ()
  (interactive)
  (ebadget
   :name   "*Slogan*"
   :update 'ebadget:slogan:update
   :interval 30))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(provide 'ebadget-slogan)
