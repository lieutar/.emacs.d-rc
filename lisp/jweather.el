;;; jweather.el --- 
;; -*- coding: utf-8 -*-
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

(defvar jweather:wget-program-name "wget")
(defvar jweather:cache-directory "~/.emacs.d/jweather")
(defvar jweather:weather-chart:url-prefix
  "http://www.jma.go.jp/jp/g3/images/observe")
(defvar jweather:weather-chart:url-suffix
  ".png")
(defvar jweather:weather-chart:pixel-size 256)
(defvar jweather:image-magick:convert "convert")
;;
(defvar jweather:image-magick:convert:additional-options
  '("-sharpen" "1x1"))

(defvar jweather:newest-data:url
  "http://www.data.jma.go.jp/obd/stats/data/mdrr/synopday/data1s.html")

(defvar jweather:default-position
  "東京")

(defvar jweather:newest-data:fields '("現地平均気圧"
                                      "海面平均気圧"
                                      "海面最低気圧"
                                      "海面最低気圧起時"
                                      "平均気温"
                                      "最低気温"
                                      "最低気温起時"
                                      "最高気温"
                                      "最高気温起時"
                                      "平均蒸気圧"
                                      "平均湿度"
                                      "最小湿度"
                                      "最小湿度起時"
                                      "平均風速"
                                      "最大風速"
                                      "最大時風向き"
                                      "最大風速起時"
                                      "瞬間最大風速"
                                      "瞬間最大時風向き"
                                      "瞬間最大風速起時"
                                      "日照時間"
                                      "全天日射量"
                                      "平均雲量"
                                      "降水量合計"
                                      "1時間あたり最大降水量"
                                      "1時間あたり最大降水起時"
                                      "10分あたり最大降水量"
                                      "10分あたり最大降水起時"
                                      "積雪量"
                                      "最新積雪"
                                      "概況1"
                                      "概況2"))
(defvar jweather:gadget:display-fields
  '("海面平均気圧"    "海面最低気圧"    "海面最低気圧起時"
    "平均気温"    "最低気温"    "最高気温"
    "平均湿度"
    ))

(defun jweather:cache-directory ()
  (unless (file-exists-p jweather:cache-directory)
    (make-directory jweather:cache-directory))
  jweather:cache-directory)

(defun jweather:weather-chart:image-name (&optional time)
  (let* ((dt   (decode-time (or time (current-time))))
         (hour (nth 2 dt))
         (day  (nth 3 dt))
         (mon  (nth 4 dt))
         (year (nth 5 dt))
         (hour (* (1- (floor (/ hour 3))) 3)))
    (when (< hour 3)
      (setq hour 21)
      (setq day (1- day))
      (when (< day 0)
        (setq mon (1- mon))
        (when (< mon 1)
          (setq mon 12)
          (setq year (1- year)))
        (setq day (cond ((= mon 2)
                         (zerop (mod year 4)) 29 28)
                        ((member mon '(1 3 5 7 8 10 12))
                         31)
                        (t 30)))))
    (format "%02d%02d%02d%02d"
            (mod year 100)
            mon
            day
            hour)))

(defun jweather:weather-chart:url (&optional time)
  (format "%s/%s%s"
          jweather:weather-chart:url-prefix
          (jweather:weather-chart:image-name time)
          jweather:weather-chart:url-suffix))

(defun jweather:weather-chart:cache-name (&optional time)
  (expand-file-name
   (format "%s%s"
           (jweather:weather-chart:image-name time)
           jweather:weather-chart:url-suffix)
   (jweather:cache-directory)))
;;(jweather:weather-chart:cache-name)
;;(jweather:weather-chart:url)


(defun jweather:weather-chart:resized-name (&optional time size)
  (expand-file-name
   (format "%s.%s%s"
           (jweather:weather-chart:image-name time)
           (or size jweather:weather-chart:pixel-size)
           jweather:weather-chart:url-suffix)
   (jweather:cache-directory)))

(defun jweather:weather-chart:get (&rest opts)
  (let* 
      ((time  (or (plist-get opts :time) (current-time)))
       (cb    (or (plist-get opts :cb)   (lambda (&rest args))))
       (cf    (jweather:weather-chart:cache-name time)))
    (if (file-exists-p cf)
        (progn
          (funcall cb cf))
      (progn
        (let* ((default-directory (jweather:cache-directory))
               (url (jweather:weather-chart:url))
               (buf (generate-new-buffer "*jweather get*"))
               (proc (start-process "jweather:get-weather-chart"
                                    buf
                                    jweather:wget-program-name
                                    "--output-document" cf
                                    url)))
          (set-process-sentinel
           proc `(lambda (&rest args)
                   (when (and args
                              (equal "finished\n" (cadr args)))
                     (kill-buffer ,buf)
                     (funcall ',cb ,cf)))))))
    cf))
;;(jweather:weather-chart:get :cb 'find-file)

(defun jweather:weather-chart:get-resized (&rest opts)
  (let*
      ((time (plist-get opts :time))
       (cb   (or (plist-get opts :cb)   (lambda (&rest args))))
       (size (or (plist-get opts :size) jweather:weather-chart:pixel-size))
       (copts (or
               (plist-get opts :options)
               jweather:image-magick:convert:additional-options))
       (cf   (jweather:weather-chart:resized-name time size)))
    (if (file-exists-p cf)
        (progn
          (funcall cb cf))
      (progn
        (let*
            ((buf      (generate-new-buffer "*jweather convert*"))
             (sentinel
              `(lambda (&rest args)
                 (when args
                   (let ((sig (cadr args)))
                     (cond 
                      ((equal "finished\n" sig)
                       (kill-buffer ,buf)
                       (funcall ',cb ,cf))
                      ((string-match "^exited abnormally with code" sig)
                       (error "convert failed.\n%S"
                              (save-excursion
                                (set-buffer ,buf)
                                (buffer-substring-no-properties
                                 (point-min)(point-max))))
                       (kill-buffer ,buf))))))))
          (jweather:weather-chart:get
           :time time
           :cb
           `(lambda (src)
              (progn
                (let* ((default-directory (jweather:cache-directory))
                       (cmdline  (list jweather:image-magick:convert
                                       "-resize" (format "%sx%s"
                                                         ,size
                                                         ,size)
                                       ,@copts
                                       src
                                       ,cf))
                       (proc (apply
                              'start-process "jweather:convert" ,buf
                              cmdline)))
                  (message "%S" cmdline)
                  (set-process-sentinel  proc ,sentinel))))))))
    cf))
;;(jweather:weather-chart:get-resized :cb  'find-file :size 300)

(defun jweather:newest-data:parse (src)
  (let ((src (let ((R ()))
               (while (string-match "^<td[^>]*>\\([^<]*\\).*?<td" src)
                 (setq R   (cons (match-string 1 src) R))
                 (setq src (replace-regexp-in-string
                            (concat "^" (regexp-quote (match-string 0 src)))
                            "<td"
                            src))
                 )
               (reverse R)))
        (R ())
        (i  0))
    (dolist (prop jweather:newest-data:fields)
      (setq R (cons (cons prop (nth i src)) R))
      (setq i (1+ i)))
    (reverse R)))



(defun jweather:newest-data:get (&rest args)
  (let* ((pos  (or (plist-get args :pos) jweather:default-position))
         (cb   (or (plist-get args :cb) 'identity))
         (buf  (generate-new-buffer "*jweather:get-newest*"))
         (process-coding-system-alist `((,jweather:wget-program-name 
                                         . (nil . nil))))
         (proc (start-process "*jweather:get-newest*"
                              buf
                              jweather:wget-program-name
                              "-o" "/dev/null"
                              "--output-document" "-"
                              jweather:newest-data:url)))
    (set-process-sentinel
     proc
     `(lambda (&rest args)
        (when args
          (let ((sig (cadr args)))
            (cond 
             ((equal sig "finished\n")
              (let* ((str
                      (save-excursion
                        (set-buffer ,buf)
                        (goto-char (point-min))
                        (when (re-search-forward
                               (concat
                                "<tr class=\"o1\"><td class=\"o0\">"
                                (regexp-quote ,pos)
                                "</td>\\(.*?\\)</tr>")
                               nil t)
                          (match-string 1))))
                     (data (when str
                             (jweather:newest-data:parse str))))
                (funcall ',cb data))
              (kill-buffer ,buf))
             ((string-match "^exited abnormally with code" sig)
              (kill-buffer ,buf)))))))
    ))
;;(jweather:newest-data:get :cb (lambda (dat) (insert (format "%S" dat))))


(defvar jweather:gadget:buffer nil)
(defvar jweather:gadget:timer  nil)

(defun jweather:gadget:callback:newest (data)
  (when (buffer-live-p jweather:gadget:buffer)
    (save-excursion
      (set-buffer jweather:gadget:buffer)
      (let ((buffer-read-only nil))
        (dolist (prop jweather:gadget:display-fields)
          (insert prop " "
                  (cdr (or (assoc prop data)
                           (cons nil "")))
                  "\n"))))))

(defun jweather:gadget:callback:resized (file)
  (when (buffer-live-p jweather:gadget:buffer)
    (save-excursion
      (set-buffer jweather:gadget:buffer)
      (let ((buffer-read-only nil))
        (delete-region (point-min) (point-max))
        (insert-image (create-image file))
        (insert "\n")
        (jweather:newest-data:get :cb 'jweather:gadget:callback:newest)))))

(defun jweather:gadget:start-timer ()
  (unless jweather:gadget:timer
    (setq jweather:gadget:timer
          (run-at-time
           "0 sec"
           (* 60 60)
           (lambda ()
             (if (buffer-live-p jweather:gadget:buffer)
                 (save-excursion
                   (set-buffer jweather:gadget:buffer)
                   (setq buffer-read-only t)
                   (setq cursor-type nil)
                   (jweather:weather-chart:get-resized
                    :cb 'jweather:gadget:callback:resized)))
             (when jweather:gadget:timer
               (cancel-timer jweather:gadget:timer)
               (setq jweather:gadget:timer nil)))))))

(defun jweather:gadget ()
  (interactive)
  (unless (buffer-live-p jweather:gadget:buffer)
    (when jweather:gadget:timer
      (cancel-timer jweather:gadget:timer))
    (setq jweather:gadget:buffer (get-buffer-create "*jweather:gadget*")))
  (jweather:gadget:start-timer)
  (switch-to-buffer jweather:gadget:buffer))

(provide 'jweather)
;;; jweather.el ends here
