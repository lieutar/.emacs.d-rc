;;-*- coding: utf-8 -*-

(rc-load "myenv-gadget-clock")

(make-face 'myenv:gadget:slogan:face)
(set-face-attribute 'myenv:gadget:slogan:face nil
                    :font          "DFPMaruGothic-Md"
                    :height        3.0
                    :weight        'normal
                    :inverse-video nil
                    :foreground    "#C33")

(defun myenv:gadget:slogan:update ()
  (delete-region (point-min) (point-max))
  (setq cursor-type nil)
  (insert (propertize "戦略的整理の励行\n"
                      'face 'myenv:gadget:slogan:face)))

(defun myenv:gadget:slogan ()
  (interactive)
  (myenv:gadget
   :name "*Slogan*"
   :update 'myenv:gadget:slogan:update))
    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
