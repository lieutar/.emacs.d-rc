(rc-ext
 :name 'jaspace
 :load 'jaspace
 :get "http://homepage3.nifty.com/satomii/software/jaspace.el"
 :init
 (lambda ()
   ;;
   ;; SEE ALSO
   ;; (browse-url "http://ubulog.blogspot.com/2007/09/emacs_09.html")
   ;;

   ;; 全角空白を表示させる。
   (setq jaspace-alternate-jaspace-string "□")
   ;; 改行記号を表示させる。
   (setq jaspace-alternate-eol-string "↓\n")
   ;; タブ記号を表示。
   ;;(setq jaspace-highlight-tabs t)  ; highlight tabs

   ;; EXPERIMENTAL: On Emacs 21.3.50.1 (as of June 2004) or 22.0.5.1, a tab
   ;; character may also be shown as the alternate character if
   ;; font-lock-mode is enabled.
   ;; タブ記号を表示。
   (setq jaspace-highlight-tabs ?>) ; use ^ as a tab marker


   ))