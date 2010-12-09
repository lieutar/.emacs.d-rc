(rc-ext
 :load  'actionscript-mode
 :get   "http://blog.pettomato.com/content/actionscript-mode.el"
 :autoload 'actionscript-mode
 :preload
 (lambda ()
   (setq auto-mode-alist
         (cons '("\\.as\\'". actionscript-mode)
               auto-mode-alist)))
 :init
 (lambda ()
   (require 'cl)

   ;; (load "actionscript-mode")
   (defconst mycfg-darkify-rate  0.75)
   (defconst mycfg-color-max (+ 0.0 (car (color-values "#FFFFFF"))))
   (defun mycfg-darkify (c)
     (let*
         ((rgb      (color-values c))
          (r        (car rgb))
          (g        (cadr rgb))
          (b        (caddr rgb))
          (r-max    (and (> r g) (> r b)))
          (r-min    (and (< r g) (< r b)))
          (g-max    (and (> g r) (> g b)))
          (g-min    (and (< g r) (< g b)))
          (b-max    (and (> b g) (> b r)))
          (b-min    (and (< b g) (< b r))))
       (when r-min (setq r 0))
       (when g-min (setq g 0))
       (when b-min (setq b 0))
       (when g-max 
         (setq r (* mycfg-darkify-rate r))
         (setq g (* mycfg-darkify-rate g))
         (setq b (* mycfg-darkify-rate b)))
       (concat
        "#"
        (mapconcat
         (lambda (v)
           
           (format "%02x"  (round (* 255 (/ (+ 0.0 v) mycfg-color-max)))))
         (list r g b)
         ""))))

   (let ((faces (apply 'append
                       (mapcar (lambda (f)
                                 (let ((name (symbol-name f)))
                                   (when (string-match "actionscript-" name)
                                     (list f))))
                               (face-list)))))
     (mapcar
      (lambda (f)
        (let* ((fg     (face-foreground f))
               (new-fg (mycfg-darkify fg)))
          (set-face-foreground f new-fg)
          ))
      faces))))
