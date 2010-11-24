(when (featurep 'elscreen)
  (let ((width (cdr (assq 'width (frame-parameters (selected-frame))))))
    (cond
     ((<= 166 width)
      (split-window-vertically)
      (split-window-horizontally)
      (let ((agenda "~/memo/agenda.org"))
        (when (file-readable-p agenda)
          (other-window 2)
          (find-file agenda)
          (other-window 1)))
      (display-about-screen)

      (elscreen-create)
      (split-window-horizontally)
      
      (elscreen-create)
      (split-window-horizontally)
      
      (elscreen-create)
      (split-window-horizontally)
    
      (elscreen-next)
      )

     ((<= 90 width)
      (elscreen-create)
      ;;(split-window-horizontally 85)
      (elscreen-create)
      ;;(split-window-horizontally 85)
      (elscreen-create)
      ;;(split-window-horizontally 85)
      (elscreen-next)
      ))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

