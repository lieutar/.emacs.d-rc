(rc-ext
 :load 'moz
 :get  "http://github.com/bard/mozrepl/raw/master/chrome/content/moz.el"
 :autoload '(moz-minor-mode
             inferior-moz-start-process
             moz-send-region)
 :init
 (lambda ()
   (add-hook 'js2-mode-hook 'my-js2-mode-hook)

   (defun my-js2-mode-hook ()
     (moz-minor-mode t)
     )

   (defun mozrepl ()
     (interactive)
     (unless (and inferior-moz-buffer
                  (buffer-live-p inferior-moz-buffer))
       (inferior-moz-start-process))
     (switch-to-buffer inferior-moz-buffer))

   (defun mozscratch ()
     (interactive)
     (switch-to-buffer
      (or (get-buffer "*moz-scratch*")
          (let ((buf (get-buffer-create "*moz-scratch*")))
            (set-buffer buf)
            (js2-mode)
            buf))))

   (defun my-moz-send-region (start end)
     (interactive (if mark-active
                      (list (region-beginning) (region-end))
                    (list (point-min) (point-max))))
     (moz-send-region start end))

   (define-key moz-minor-mode-map (kbd "C-c C-r") 'my-moz-send-region)

   (defvar my-rc-firefox-launcher-name
     "cygstart")

   (defvar my-rc-firefox-program-name
     "c:/Program Files/Mozilla Firefox/firefox.exe")

   ))
