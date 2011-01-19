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
   ;;(setq jaspace-alternate-eol-string "↓\n")
   ;;(setq jaspace-alternate-eol-string "\n")


   ;; タブ記号を表示。
   (setq jaspace-highlight-tabs ?>) ; use ^ as a tab marker


   ))
