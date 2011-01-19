(rc-ext
 :load (lambda ()
         (require 'color-moccur)
         (require 'moccur-edit))
 :autoload
 '(moccur                             moccur-edit-finish-edit
   moccur-edit-kill-all-change
;;   moccur-edit-mode-in
   moccur-edit-remove-change          moccur-edit-remove-overlays
   moccur-edit-reset-key              moccur-file-beginning-of-buffer
   moccur-file-end-of-buffer          moccur-file-scroll-down
   moccur-file-scroll-up              moccur-flush-lines
   moccur-grep                        moccur-grep-find
   moccur-grep-goto                   moccur-keep-lines
   moccur-kill-line

   moccur-mode-change-face
   moccur-mode-goto-occurrence
   moccur-mode-kill-file
   moccur-mode-undo

;;   moccur-mouse-goto-occurrence
;;   moccur-mouse-select1

   moccur-narrow-down
   moccur-next                        moccur-next-file
   moccur-prev                        moccur-prev-file
   moccur-quit                        moccur-remove-overlays-on-all-buffers

;;   moccur-scroll-down                 moccur-scroll-up

   moccur-search-undo                 moccur-search-update
   moccur-switch-buffer               moccur-toggle-buffer
   moccur-toggle-view
   )
 :get  (lambda ()
         (rc-get "http://www.bookshelf.jp/elc/color-occur.el")
         (rc-get "http://www.bookshelf.jp/elc/color-moccur.el")
         (rc-get "http://www.bookshelf.jp/elc/moccur-edit.el")
         )
 :init
 (lambda ()
   (defvar my-moccur-cancel-delete-windows nil)
   (dolist (func '(moccur-search
                   moccur-search-files
                   moccur-grep-sync-kill-buffers
                   moccur-mode-goto-occurrence
                   search-buffer-goto))
     (eval `(defadvice ,func (around my-rc:moccur activate)
              (let ((my-moccur-cancel-delete-windows t))
                ad-do-it))))
   (defadvice delete-other-windows (around my-rc:moccur activate)
     (unless my-moccur-cancel-delete-windows
       ad-do-it))
   ))
