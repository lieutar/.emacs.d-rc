(rc-ext
 :name     'gtags
 :autoload '(gtags-find-tag
             gtags-find-rtag
             gtags-find-symbol
             gtags-find-pattern
             gtags-find-file
             gtags-pop-stack)
 :init
 (lambda ()
   (require 'gtags)
   (global-set-key "\M-t" 'gtags-find-tag)     ;関数の定義元へ
   (global-set-key "\M-r" 'gtags-find-rtag)    ;関数の参照先へ
   (global-set-key "\M-s" 'gtags-find-symbol)  ;変数の定義元/参照先へ
   (global-set-key "\M-p" 'gtags-find-pattern)
   (global-set-key "\M-f" 'gtags-find-file)    ;ファイルにジャンプ
   (global-set-key [?\C-,] 'gtags-pop-stack)   ;前のバッファに戻る
   ))

