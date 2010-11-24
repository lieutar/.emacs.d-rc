;; -*- coding: utf-8 -*-
;;
;; フォントの設定
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;あああああああああああああああああああああああああああああああああああああああ

(when window-system
  (let (my-font-height my-font my-font-ja my-font-size my-fontset)
    (setq scalable-fonts-allowed t)
    (setq w32-enable-synthesized-fonts t)
    ;;(setq my-font-height 100)
    (setq my-font-height 80)
    ;;(setq my-font "ＭＳ ゴシック")
    ;;(setq my-font "VL ゴシック")
    ;;(setq my-font "IPAゴシック")
    ;;(setq my-font "Takaoゴシック")
    ;;(setq my-font "Inconsolata")
    (setq my-font "Consolas")
    ;;(setq my-font "DejaVu Sans Mono")
    (setq my-font-ja "ＭＳ ゴシック")
    ;;(setq my-font-ja "VL ゴシック")
    ;;(setq my-font-ja "IPAゴシック")
    ;;(setq my-font-ja "Takaoゴシック")
    ;;(setq my-font-ja "メイリオ")
    ;; ime-font の設定がわからん

    ;; フォントサイズの微調節 (10ptで合うように)
    (setq face-font-rescale-alist
          '((".*ＭＳ.*bold.*iso8859.*" . 0.9)
            (".*ＭＳ.*bold.*jisx02.*"  . 0.95)
            (".*DejaVu Sans.*"         . 0.9)
            (".*メイリオ.*"            . 1.1)
            ("-cdac$"                  . 1.3)))

    ;;(dolist (e face-font-rescale-alist)
    ;; (setcar e (encode-coding-string (car e) 'emacs-mule)))

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


(setq default-frame-alist
      (cons '(height . 72)
            default-frame-alist))
