(require 'easy-mmode)

(easy-mmode-define-minor-mode
 del-window-with-confirming-mode
 "Toggles del-window-with-confirming-mode.
With no argument. this command toggles the minor mode.
Non-nil argument activates the minor mode.
Nil argument deactivates the minor mode."
 nil
 ""
 nil)

(easy-mmode-define-global-mode
 global-del-window-with-confirming-mode
 del-window-with-confirming-mode
 (lambda (&rest args) (apply 'del-window-with-confirming-mode args)))

(defun del-window-with-confirming-init (specs)
  (dolist (spec specs)
    (let ((cmd (car spec))
          (msg (cadr spec)))
      (eval
       `(defadvice ,cmd (around confirming activate)
          (if (called-interactively-p)
              (when (or (not del-window-with-confirming-mode)
                        (y-or-n-p ,msg))
                ad-do-it)
            ad-do-it))))))

(del-window-with-confirming-init
 '((delete-other-windows  "Do you want to delete other windows? ")
   (delete-window         "Do you want to delete current window? ")))

(del-window-with-confirming-init
 '((bubble-window  "Do you want to delete sibling windows? ")))

(global-del-window-with-confirming-mode t)
