(require 'ebadget)

(defconst ebadget:timers (make-hash-table :test 'equal))

(defconst ebadget:clock:image-dir 
  (expand-file-name "img/" (file-name-directory (locate-library "ebadget-clock"))))

(defconst ebadget:clock:moon-phase-names '(new-moon
                                           waxing-crescent
                                           first-quater
                                           waxing-gibbous
                                           full-moon
                                           waning-gibbous
                                           last-quater
                                           waning-crescent))

(defface ebadget:clock:face
  '((((class color))
     (
      :height 2.0
      :weight ultrabold
              )))
  "base face of ebadget"
  :group 'convinience)

(defface ebadget:clock:time-face
  '((((class color))
     (
      :height 2.0
      :weight ultrabold
              )))
  "base face of ebadget"
  :group 'convinience)

(defface ebadget:clock:date-face
  '((((class color))
     (
      :height 1.0
      :weight ultrabold
              )))
  "base face of ebadget"
  :group 'convinience)




(defsubst ebadget:clock:moon-phase:yday (day mon year)
  ;;             1 2  3  4  5   6   7   8   9   10  11  12
  (let* ((bases '(0 31 59 90 120 151 181 212 243 273 304 334))
         (base  (nth (1- mon) bases)))
    (+ day (if (and (> mon 2)
                    (or (zerop (mod year 400))
                        (and (not (zerop (mod year 400)))
                             (zerop (mod year 4))))) 1 0) base)))

(defun ebadget:clock:moon-phase (time-or-day &optional mon year)
  (let (day)
    (if year
        (setq day time-or-day)
      (let ((lt    (decode-time time-or-day)))
         (setq day   (nth 3 lt))
         (setq mon   (nth 4 lt))
         (setq year  (nth 5 lt))))
    (let* ((diy   (ebadget:clock:moon-phase:yday day mon year))
           (goldn (1+ (mod year 19)))
           (epact (mod (+ (* 11 goldn) 18) 30)))
      (nth (logand
            (/ (mod (+ 11 (* 6 (+ diy epact
                                  (if (or (and (eq epact 25)
                                               (> goldn 11))
                                          (eq epact 24)) 1 0)))) 177) 22)
            7)
           ebadget:clock:moon-phase-names))))



(defun ebadget:clock:current-time-string ()
  (format-time-string " %m/%d(%a) %H:%M:%S "))

(defun ebadget:clock:current-time-string-with-face ()
  (propertize (ebadget:clock:current-time-string)
              'face 'ebadget:clock:face))

(defun ebadget:clock:current-face ()
  'ebadget:clock:face)


(defun ebadget:clock:moon-phase-image (name)
  (append
   (create-image
    (expand-file-name (format "%s.png" name)
                      ebadget:clock:image-dir))
   (list :ascent 'center
         :pointer 'arrow)))

(defun ebadget:clock:moon-phase-image-string (name)
  (propertize (format "%s" name)
              'display
              (ebadget:clock:moon-phase-image name)))


(defun ebadget:clock:update ()
  (delete-region (point-min)(point-max))
  (setq cursor-type nil)
  (insert 
   (propertize 
    (concat
     (ebadget:clock:current-time-string)
     (ebadget:clock:moon-phase-image-string
      (ebadget:clock:moon-phase (current-time)))
     "\n\n")
    'face (ebadget:clock:current-face))))


(defun ebadget:clock ()
  (interactive)
  (ebadget :name   "ebadget:clock"
           :update 'ebadget:clock:update))

(provide 'ebadget-clock)
