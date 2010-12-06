(rc-ext
 :load 'skk
 :autoload '(skk-mode)

 :get 
 (lambda ()
   (browse-url "http://openlab.ring.gr.jp/skk/maintrunk/"))

 :preload
 (lambda ()
   (global-set-key [?\C-x ?\C-j] (function skk-mode))
   )

 :init
 (lambda ()

   (defconst my-skk-weekday-name-list
     (split-string "Mon Tue Wed Thu Fri Sat Sun" " "))

   (defconst my-skk-month-name-list
     (split-string "Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec" " "))

   (defun my-skk-default-current-date-function (date-information
                                                format
                                                gengo
                                                and-time)
     (let ((Y (nth 0 date-information))
           (M (nth 1 date-information))
           (D (nth 2 date-information))
           (w (nth 3 date-information))
           (h (nth 4 date-information))
           (m (nth 5 date-information))
           (s (nth 6 date-information)))
       (format "[%04d-%02d-%02d %s %02d:%02d:%02d]"
               (string-to-number Y)
               (- 13 (length (member M my-skk-month-name-list)))
               (string-to-number D)
               w
               (string-to-number h)
               (string-to-number m)
               (string-to-number s)
               )))

   (setq skk-default-current-date-function
         (function my-skk-default-current-date-function))


                                        ;-*- emacs-lisp -*-
   (setq skk-server-host "localhost")
   ;;(setq skk-server-prog "/usr/local/libexec/dbskkd-cdb.exe")
   ;;(if (eq system-type 'cygwin) (load-file "~/.emacs.d/.skk.cygwin"))

   (setq skk-rom-kana-rule-list
         (rc-put-alist '(("."  nil "．")
                         (","  nil "，")
                         ("?"  nil "?")
                         ("@"  nil "@")
                         (":"  nil ":")
                         (";"  nil ";")
                         ("wi" nil ("ヰ" . "ゐ"))
                         ("we" nil ("ヱ" . "ゑ"))
                         ("vya" nil ("ヴャ" . "う゛ゃ"))
                         ("vyu" nil ("ヴュ" . "う゛ゅ"))
                         ("vyo" nil ("ヴョ" . "う゛ょ")))
                       skk-rom-kana-rule-list))

   (setq skk-use-jisx0201-input-method t)
   (add-hook 'skk-mode-hook (lambda () (require 'skk-jisx0201)))
   ))
