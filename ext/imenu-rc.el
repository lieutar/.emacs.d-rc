(rc-ext
 :load 'imenu
 :init 
 (lambda ()
   (defvar my-imenu-modes '(emacs-lisp-mode c-mode c++-mode makefile-mode))
   (defun my-imenu-ff-hook ()
     "File find hook for Imenu mode."
     (if (member major-mode my-imenu-modes)
         (imenu-add-to-menubar "imenu")))
   (add-hook 'find-file-hooks 'my-imenu-ff-hook t)
   ))