(when (featurep 'elscreen)
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
