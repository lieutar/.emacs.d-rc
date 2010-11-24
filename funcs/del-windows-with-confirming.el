(defadvice delete-other-windows (around confirming activate)
  (if (called-interactively-p)
      (when (y-or-n-p "Do you want to delete other windows? ")
        ad-do-it)
    ad-do-it))

(defadvice bubble-window (around confirming activate)
  (if (called-interactively-p)
      (when (y-or-n-p "Do you want to delete sibling windows? ")
        ad-do-it)
    ad-do-it))


(defadvice delete-window (around confirming activate)
  (if (called-interactively-p)
      (when (y-or-n-p "Do you want to delete current window? ")
        ad-do-it)
    ad-do-it))

