;;-*- coding: utf-8 -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(rc-load "jweather")
(setq jweather:image-magick:convert "/usr/bin/convert")
(setq jweather:weather-chart:pixel-size 200)


(setq jweather:default-position
      (acman-get "*persona* formal pref"))

(rc-load "myenv-gadget-clock")
(rc-load "myenv-gadget-slogan")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar my:elsp:3cols:project nil)
(defun my:elsp:3cols:init-with-eshell (dir)
  (switch-to-buffer
   (save-window-excursion
     (let ((buf (eshell t)))
       (set-buffer buf)
       (insert "cd " dir)
       (call-interactively 'eshell-send-input)
       (let ((inhibit-read-only t))
         (delete-region (point-min)(point-max)))
       (call-interactively 'eshell-send-input)
       buf))))

(defun my:elsp:ws-vertically (size window op)
  (let* ((window (cond ((null    window) (selected-window))
                       ((windowp window) window)
                       ((symbolp window) 
                        (let ((wplist (elsp:get-window-plist-by-name window)))
                          (unless wplist (error "undefined window: %s" window))
                          (plist-get wplist :window)))))
         (size   (if (> size 0) size (+ size (frame-parameter
                                              (window-frame window) 'height))))
        (height (window-height window)))
    (when (funcall op height size)
      (enlarge-window (- size height)))))

(defun my:elsp:widen-vertically (size &optional window)
  (my:elsp:ws-vertically size window '<))

(defun my:elsp:shlink-vertically (size &optional window)
  (when nil
    (my:elsp:ws-vertically size window '>)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(elsp:set-environment
 '(0 main)
 '((main
    :color      ("#554433" . "#F8F8F0")
    :focus      agenda
    :pop-to     tw-home
    :preinit
    (lambda () (save-window-excursion (calendar)))
    :composition

    ((|)
     ((- :size 84)
      (:size 8
       :name calendar
       :init (lambda () (switch-to-buffer calendar-buffer)))
      (:name find-git
       :pop-to eshell
       :init (lambda () (find-git "~" :popup 'current-window)))
      (:name eshell
       :pop-to find-git
       :init (lambda () (my:elsp:3cols:init-with-eshell "~"))))

     ((-)
      ((| :size 50)
       ((- :size 116)
        (:size 4
         :name slogan
         :init (lambda () (myenv:gadget:slogan)))
        (:name  agenda
         :init (lambda ()
                 (when (file-readable-p "~/memo/agenda.org")
                   (find-file  "~/memo/agenda.org")
                   (when (>= emacs-major-version 23)
                     (text-scale-set 2))
                   (and (re-search-forward "^\\*\\* Log" nil t)
                        (beginning-of-line))))))

       ((-)
        (:size 4
         :name clock
         :init (lambda () (myenv:gadget:clock)))
        (:name jweather
         :init (lambda () (jweather:gadget)))
        (:name scratch
         :init (lambda () (switch-to-buffer "*scratch*")))))

      ((|)
       (:name tw-home
        :init (lambda () (twit))
        :pop-to tw-mentions)
       (:name tw-mentions
        :init (lambda () (twittering-visit-timeline ":mentions"))))))
    );; end of main

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   (project
    :pop-to      'code-3
    :args        ()
    :composition
    ((|)
     ((- :size 84)
      (:size 8 :name 'project-info
               :init (lambda () (project:gadget)))
      (:size nil :name dirs  :init (lambda () (project:dired)))
      (:size nil :name shell :init (lambda () (project:shell))))
     ((- :size 84)
      (:size 50  :name code-0)
      (:size nil :name code-1))
     ((- :size nil)
      (:size 50  :name code-2)
      (:size nil :name code-3 :pop-to code-1)))
    );;end of project


   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   (project
     :focus main-1
     :preinit (lambda ()
                (setq my:elsp:3cols:project
                      (when (y-or-n-p "Creats new screen with directory? ")
                        (read-directory-name "base: "))))
     :pop-to info
     :composition
     ((|)
      ((- :size 85)
       (:name dired :size nil :init
              (lambda () (when my:elsp:3cols:project
                           (dired my:elsp:3cols:project))))
       (:name shell  :size nil :init
              (lambda () (when my:elsp:3cols:project
                           (my:elsp:3cols:init-with-eshell
                            my:elsp:3cols:project)))))
      ((-)
       ((| :size 50)
        (:name main-1
         :onfocus (lambda () (my:elsp:widen-vertically -10))
         :init (lambda () (when my:elsp:3cols:project
                            (dired my:elsp:3cols:project))))
         
        (:name main-3
         :onfocus (lambda () (my:elsp:widen-vertically -10))
         :init (lambda () (when my:elsp:3cols:project
                            (dired my:elsp:3cols:project)))))

       (:name info  :size nil :pop-to main-1
        :onfocus (lambda () (my:elsp:widen-vertically 40))
        :init (lambda () (when my:elsp:3cols:project
                           (dired my:elsp:3cols:project)))))
      );; end of composition
     );;end of project

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   (default
     :focus main-1
     :pop-to info
     :composition
     ((-)
      ((| :size 4)
       (:name slogan :size 85 :init (lambda () (myenv:gadget:slogan)))
       (:name clock  :init (lambda () (myenv:gadget:clock))))
      ((| :size 50)

       (:name main-1 :size 85
         :onfocus (lambda () (my:elsp:widen-vertically -10))
         :init (lambda () (switch-to-buffer "*scratch*")))

       (:name main-2 :size 85
        :onfocus (lambda () (my:elsp:widen-vertically -10))
        :init (lambda () (switch-to-buffer "*scratch*")))

       (:name main-3
        :onfocus (lambda () (my:elsp:widen-vertically -10))
        :init (lambda ()  (switch-to-buffer "*scratch*"))))

      (:name info  :size nil :pop-to main-1
       :onfocus (lambda () (my:elsp:widen-vertically 40))
       :init (lambda () (switch-to-buffer "*scratch*")))
      );; end of composition
     );;end of default

   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   )
)

