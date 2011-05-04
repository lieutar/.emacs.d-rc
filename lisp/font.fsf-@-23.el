;; -*- coding: utf-8 -*-
;;
;; フォントの設定
;;
;; see-also http://moimoitei.blogspot.com/2010/05/font-fot-emacs-23.html
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;あああああああああああああああああああああああああああああああああああああああ

(defun my-rc-init-font (&rest spec)
  (let ((my-font          (plist-get spec :base))
        (my-font-ja       (plist-get spec :ja))
        (my-font-height   (or (plist-get spec :height) 100))
        (my-font-size     (plist-get spec :pixel-size))
        (my-rescale-alist (plist-get spec :rescale-alist))
        my-fontset)
    
    (setq scalable-fonts-allowed t)
    (setq w32-enable-synthesized-fonts t)
  
    ;; フォントサイズの微調節 (10ptで合うように)
    ;; http://macemacsjp.sourceforge.jp/matsuan/FontSettingJp.html
    (setq face-font-rescale-alist
          (mapcar
           (lambda (slot)
             (cons (encode-coding-string (car slot) 'emacs-mule)
                   (cdr slot)))
           `(,@my-rescale-alist
             (".*ＭＳ.*bold.*iso8859.*" . 1.0)
             (".*ＭＳ.*bold.*jisx02.*"  . 1.0)
             (".*DejaVu Sans.*"         . 0.9)
             (".*メイリオ.*"            . 1.1)
             (".*IPAゴシック.*"         . 1.5)
             ("-cdac$"                  . 1.3))))

  
  ;; デフォルトフォント設定
  (cond
   ;; pixel 単位で指定
   ((and my-font-size my-font)
    (setq my-fontset
          (create-fontset-from-ascii-font
             (format "%s:size=%d" my-font my-font-size))))
   ;; 高さを pt 単位で指定
   (my-font
    (set-face-attribute 'default nil :family my-font :height my-font-height)
    ;;(set-frame-font (format "%s-%d" my-font (/ my-font-height 10)))
    )
   )

  (when my-fontset
    (add-to-list 'default-frame-alist `(font . ,my-fontset) t))

    ;; 日本語文字に別のフォントを指定
    (when my-font-ja
      (let ((fn (or my-fontset (frame-parameter nil 'font)))
            (rg "iso10646-1"))
        (set-fontset-font fn 'katakana-jisx0201 `(,my-font-ja . ,rg))
        (set-fontset-font fn 'japanese-jisx0208 `(,my-font-ja . ,rg))
        (set-fontset-font fn 'japanese-jisx0212 `(,my-font-ja . ,rg)))
      )
    ))

(cond 
 ((equal system-name "cotreefrog")
    (my-rc-init-font
     :base  "IPAGothic"
;;     :base  "さざなみゴシック";; :ja    "ＭＳ ゴシック"
     :height 80
     :rescale-alist
     '((".*iso8858.*" . 0.8)
       (".*jisx02.*" . 0.8)))
    )
 ((equal system-name "comisuzu")
  )
 (t
  (my-rc-init-font
   ;; :base  "Consolas";; :ja    "ＭＳ ゴシック"
   :base  "さざなみゴシック";; :ja    "ＭＳ ゴシック"
   ;; :base "メイリオ" :ja "メイリオ"
   ;; :base  "IPAゴシック"  :ja    "IPAゴシック"
   :height 75
   :rescale-alist
   '((".*ＭＳ.*bold.*iso8859.*" . 0.8)
   (".*ＭＳ.*bold.*jisx02.*"  . 0.8)))))
  


;あああああああああああああああああああああああああああああああああああああああ
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;あああああああああああああああああああああああああああああああああああああああ
;\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

;;(assq 'height (frame-parameters nil))

(modify-frame-parameters
 (selected-frame)
 (setq default-frame-alist
       (append `((height . ,(rc-emacsen-case 
                             (fsf-nt-23     72)
                             (fsf-cygwin-23 75)
                             (fsf-unicom-23
                              (cond
                               ((equal system-name "cotreefrog")
                                74)))
                             )))
                 default-frame-alist)))

