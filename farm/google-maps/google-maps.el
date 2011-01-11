(when nil
  (browse-url
   "http://code.google.com/intl/ja/apis/maps/documentation/staticmaps/")
)

(require 'kael-http)
(defvar google-maps-default-width   512)
(defvar google-maps-default-height  512)
(defvar google-maps-default-zoom    14)
(defvar google-maps-default-format  "png"
  ;; png, jpeg, gif
  )
(defvar google-maps-default-maptype "roadmap"
  )
(defvar google-maps-default-lang "ja")
(defvar google-maps-default-sensor "false")

(defun google-maps-read-marker (marker)
  (when (stringp marker) (setq marker (list marker)))
  (let* ((place  (car marker))
         (plist  (cdr marker))
         (color  (or (plist-get plist :color) "red"))
         (size   (or (plist-get plist :size)  "mid")) ;; tiny mid small
         (shadow (or (plist-get plist :shadow) "true"))
         (icon   (or (plist-get plist :icon)   nil))
         (label  (or (plist-get plist :label)  nil)))
    (mapconcat
     'identity
     (apply 'append
            (list
             (list (format "color:%s" color))
             (list (format "size:%s" size))
             (list (format "shadow:%s" shadow))
             (when label (list (format "label:%s" label)))
             (when icon  (list (format "icon:%s"  icon)))
             (list place)
             ))
     "|")))

(defun google-maps-static-url (&rest arg-plist)
  (let ((Q nil))
    (dolist
        (slot
          `((:center
             :action  (lambda (arg)
                        (unless (listp arg) (setq arg (list arg)))
                        `(("center" . ,(mapconcat 'identity arg ",")))))
            (:markers
             :action  (lambda (arg)
                        (unless (listp arg) (setq arg (list arg)))
                        (mapcar
                         (lambda (marker)
                           (cons "markers"
                                 (google-maps-read-marker marker)))
                         arg)))
            (:pathes
             :action  (lambda (arg)
                        (unless (listp arg) (setq arg (list arg)))
                        (mapcar
                         (lambda (path)
                           (cons "pathes"
                                 path))
                         arg)))
            (:visible
             :action  (lambda (arg)
                        (unless (listp arg) (setq arg (list arg)))
                        `(("visible" . ,(mapconcat 'identity arg ",")))))
            (:size
             :default (,google-maps-default-width
                       ,google-maps-default-height)
             :action (lambda (arg)
                       `(("size" . ,(format "%dx%d" (car arg)(cadr arg)))))
             )

            (:maptype
             :default ,google-maps-default-maptype
             :action (lambda (arg)
                       `(("maptype" . ,arg))))
            (:zoom
             :default ,google-maps-default-zoom
             :action (lambda (arg)
                       `(("zoom" . ,(format "%s" arg))))
             )
            (:lang
             :default ,google-maps-default-lang
             :action  (lambda (arg)
                        `(("language" . ,arg))))
            (:sensor
             :default ,google-maps-default-sensor
             :action  (lambda (arg)
                        `(("sensor" . , arg))))))
      (let* ((prop      (car slot))
             (splist    (cdr slot))
             (essential (plist-get splist :essential))
             (default   (plist-get splist :default))
             (action    (plist-get splist :action))
             (arg       (or (plist-get arg-plist prop) default)))
        (if arg
            (let ((qslot (funcall action arg)))
              (setq Q (append Q qslot)))
          (when essential
            (error "property %s is not specified." prop)))))
    (format "http://maps.google.com/maps/api/staticmap?%s"
            (kael-http-make-query Q))))


(defun google-maps-static (&rest arg-plist)
  (let ((url    (apply 'google-maps-static-url arg-plist))
        (action (or (plist-get arg-plist :action) 'browse)))
    (case action
      ((browse)
       (browse-url url))
      ((insert)
       (let ((hide-url (plist-get arg-plist :hide-url)))
         (unless hide-url (insert url "\n"))
         (let* ((res     (kael-http-request  url))
                (content (plist-get res :raw-content))
                (type    (plist-get res :content-type))
                (start   (point)))
           (insert (if hide-url url " "))
           (add-text-properties start (point)
                                `(display (image :type png
                                                 :data ,content)))
           url))))))


(when nil
  (google-maps-static
   :action  'insert
   :center  "çcãè"
   :markers  '(("çcãè"
                :color "#FFBBCC"
                :size  "mid"
                :label "M"))
   :visible  '("ìåãûâw")
   :zoom    15
   ;; :maptype "terrain"
   ;; :maptype "hybrid"
   ;; :size    '(300 300)
   :size    '(400 400)
   :hide-url t)
)