;;(insert (format "%S" (cdr (assq 'font (frame-parameters (selected-frame))))))

(add-to-list 'default-frame-alist
             '(font . "-Misc-Fixed-Medium-R-Normal--10-100-75-75-C-60-ISO8859-1"))
(modify-frame-parameters (selected-frame) default-frame-alist)
