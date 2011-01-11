;;(insert (format "\n%S" (cdr (assq 'font (frame-parameters (selected-frame))))))


(add-to-list
 'default-frame-alist
 '(font . "-Misc-Fixed-Medium-R-SemiCondensed--13-120-75-75-C-60-ISO8859-1"))
(modify-frame-parameters (selected-frame) default-frame-alist)
