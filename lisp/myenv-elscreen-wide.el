

(elsx:set-environment
 '(0 main 1 twit)
 '((main
    :color      ("#554433" . "#F8F8F0")
    :focus      agenda
    :preinit    (lambda () (calendar))
    :composition
    ((|)
     ((- :size 84)
      (:size 4
       :name clock
       :init (lambda () (ebadget:clock)))
      (:name find-git
       :init (lambda () (find-git "~" :popup 'current-window)))
      (:name eshell
       :init (lambda () (eshell)))
      (:name jweather
       :init (lambda () (jweather:gadget))))

     ((-)
      (:size 8
       :name calendar
       :init (lambda () (switch-to-buffer calendar-buffer)))
      (:name  agenda
       :init (lambda ()
               (when (file-readable-p "~/memo/agenda.org")
                 (find-file  "~/memo/agenda.org")
                 (when (>= emacs-major-version 23)
                   (text-scale-set 2))
                 (and (re-search-forward "^\\*\\* Log" nil t)
                      (beginning-of-line))))))))
   (twit
    :color ("#335566" . "#F0FCFC")
    :focus tw-home
    :composition
    ((|)
     (:name tw-home     :init (lambda () (twit)))
     (:name tw-mentions :init (lambda ()
                                (twittering-visit-timeline ":mentions")))))

   (default
     :composition
     ((|)
      (:size 84)
      (:size nil))
     )))

