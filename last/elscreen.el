(when (fboundp 'elscreen-create)
  (let ((width (cdr (assq 'width (frame-parameters (selected-frame))))))
    (cond
     ((<= 166 width)
      
      (split-window-horizontally)
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
      (split-window-horizontally 85)
      (elscreen-create)
      (split-window-horizontally 85)
      (elscreen-create)
      (split-window-horizontally 85)
      (elscreen-next)
      ))))



