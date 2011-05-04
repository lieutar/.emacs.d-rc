;;(insert (format "%S" (cdr (assq 'font (frame-parameters (selected-frame))))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;あああああああああああああああああああああああああああああああああああああああ
;;(read-char "xyz:")
(when nil

  (add-to-list
   'default-frame-alist
   `(font .
          ,(or
            (cond
             ((equal system-name "cotreefrog")
              ;;"-misc-sazanami gothic-medium-r-normal--0-0-0-0-p-0-jisx0201.1976-0"
              "-Misc-Fixed-Medium-R-Normal-14-130-75-75-C-70-ISO8859-1"
              )
             ((equal system-name "comisuzu")
              "-Misc-Fixed-Medium-R-Normal-14-130-75-75-C-70-ISO8859-1"
              )
             (t
              "-Misc-Fixed-Medium-R-Normal--10-100-75-75-C-60-ISO8859-1"))
            "-Misc-Fixed-Medium-R-Normal-14-130-75-75-C-70-ISO8859-1")))

  
  (modify-frame-parameters (selected-frame) default-frame-alist)

  );; end of (progn


