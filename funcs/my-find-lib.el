(defun my-find-lib (lib)
  (interactive 
   (list (completing-read
          "lib: "
          (mapcar 'symbol-name features))))
  (let* ((elc (locate-library lib))
         (el  (when elc (replace-regexp-in-string "\\.elc$" ".el" elc))))

    (if el (find-file el)
      (error (format "%s was not found.")))))


