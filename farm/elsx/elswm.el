;;; elswm.el --- 

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(require 'cl)
(defvar elswm-mode nil)

(defgroup elswm ()
  "ELScreen Window Manager."
  )

(defcustom elswm-directory "~/.emacs.d/elswm"
  "The Directory for saving files of elswm environments and other configurarions."
  :group 'elswm
  :type  'directory
  )

(defcustom elswm-mode-lighter " elswm" 
  ""
  :group 'elswm
  :type  'string
  :set   (lambda (sym val)
           (set sym val)
           (when (fboundp 'elswm-mode:redefine)
             (elswm-mode:redefine))
           val))

(defcustom elswm-default-environment-name "default"
  ""
  :group 'elswm
  :type  'string)

(defcustom elswm:default-color-scheme 
  (let* ((alist (frame-parameters nil))
         (fore  (cdr (or (assq 'foreground-color alist) '(nil))))
         (bg    (cdr (or (assq 'background-color alist) '(nil)))))
    (cons fore bg))
  ""
  :group 'elswm
  :type '(cons (string :tag "foreground-color") 
               (string :tag "background-color")))

(defcustom elswm-layout-write-default-buffer-names '("*scratch*"
                                                     "*Messages*")
  ""
  :type '(repeat :args (string) :tag "Buffer name")
  :group 'elswm)

(defcustom elswm-ad:select-window-functions
  '(other-window
    switch-to-buffer
    mouse-drag-region
    delete-window
    add-change-log-entry-other-window
    help-do-xref
    windmove-do-window-select
    info
    help-window-setup-finish
    edebug-display-buffer
    anything-display-buffer
    )
  ""
  :type '(repeat :args (function))
  :group 'elswm
  :set (lambda (sym val)
         (set sym val)
         (when (and elswm-mode
                    (fboundp 'elswm-ad:setup))
           (elswm-ad:setup))
         val))


(require 'elswm-core)
(require 'elswm-commands)
(provide 'elswm)
;;; elswm.el ends here
