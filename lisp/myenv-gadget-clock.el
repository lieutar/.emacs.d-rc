(defconst myenv:gadget:timers (make-hash-table :test 'equal))

(defconst myenv:gadget:clock:image-dir 
  "~/.emacs.d/rc/farm/elsp-gadget/img")


(defconst myenv:moon-phase-names '(new-moon
                                   waxing-crescent
                                   first-quater
                                   waxing-gibbous
                                   full-moon
                                   waning-gibbous
                                   last-quater
                                   waning-crescent))

(defsubst myenv:moon-phase:yday (day mon year)
  ;;             1 2  3  4  5   6   7   8   9   10  11  12
  (let* ((bases '(0 31 59 90 120 151 181 212 243 273 304 334))
         (base  (nth (1- mon) bases)))
    (+ day (if (and (> mon 2)
                    (or (zerop (mod year 400))
                        (and (not (zerop (mod year 400)))
                             (zerop (mod year 4))))) 1 0) base)))

(defun myenv:moon-phase (time-or-day &optional mon year)
  (let (day)
    (if year
        (setq day time-or-day)
      (let ((lt    (decode-time time-or-day)))
         (setq day   (nth 3 lt))
         (setq mon   (nth 4 lt))
         (setq year  (nth 5 lt))))
    (let* ((diy   (myenv:moon-phase:yday day mon year))
           (goldn (1+ (mod year 19)))
           (epact (mod (+ (* 11 goldn) 18) 30)))
      (nth (logand
            (/ (mod (+ 11 (* 6 (+ diy epact
                                  (if (or (and (eq epact 25)
                                               (> goldn 11))
                                          (eq epact 24)) 1 0)))) 177) 22)
            7)
           myenv:moon-phase-names))))


(defun myenv:gadget:set-timer (name timer)
  (puthash name timer myenv:gadget:timers))

(defun myenv:gadget:stop-timer (name)
  (let ((timer (gethash name myenv:gadget:timers)))
    (when timer
      (cancel-timer timer)
      (myenv:gadget:set-timer name nil))))

(defun myenv:gadget (&rest opts)
  (let* ((name            (or (plist-get opts :name)
                              (error "property :name is required.")))
         (buffer-name    (format "*%s*" name))
         (init-command   (or (plist-get opts :init)
                             (lambda ())))
         (update-command (or (plist-get opts :update)
                             (error "property :update is required.")))
         (interval       (or (plist-get opts :interval) 1)))

    (if (get-buffer buffer-name)

        (switch-to-buffer buffer-name)

      (let ((buf (get-buffer-create buffer-name)))
        (switch-to-buffer buf)
        (funcall init-command)
        (myenv:gadget:set-timer
         name
         (run-at-time
          "0 sec"
          interval
          `(lambda ()
             (if (buffer-live-p ,buf)
                 (progn
                   (save-excursion
                     (set-buffer ,buf)
                     (setq buffer-read-only t)
                     (let ((buffer-read-only nil))
                       (funcall ',update-command))
                     )
                   )
               (progn (myenv:gadget:stop-timer ,name))))))))))

(make-face 'myenv:gadget:clock:face)
(set-face-attribute 'myenv:gadget:clock:face nil
                    :height        2.0
                    :weight        'ultrabold
                    :inverse-video nil
                    :foreground    "#678")

(defun myenv:gadget:clock:update ()
  (delete-region (point-min)(point-max))
  (setq cursor-type nil)
  (insert 
   (let ((mp (myenv:moon-phase (current-time))))
     (propertize (format "%s" mp)
                 'display
                 (create-image
                  (expand-file-name (format "%s.png" mp)
                                    myenv:gadget:clock:image-dir))))
   " "
   )
  (insert (propertize (current-time-string) 'face 'myenv:gadget:clock:face))
  )


(defun myenv:gadget:clock ()
  (interactive)
  (myenv:gadget :name "myenv:gadget:clock"
                :update 'myenv:gadget:clock:update))

