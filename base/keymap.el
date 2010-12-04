(require 'vi)
(defconst my-km-prefix [?\C-z])
(defvar   my-ctrl-z-map nil)
(global-set-key [?\C-t] nil)
(global-set-key [?\C-x ?\C-c] nil)



(let ((km (make-sparse-keymap)))
  ;; 0
  ;; 1
  ;; 2
  ;; 3
  ;; 4
  ;; 5
  (define-key km [?5]    'vi-find-matching-paren)
  ;; 6
  ;; 7
  ;; 8
  ;; 9

  ;; a
  ;; b
  (define-key km [?b]    'bury-buffer)
  ;; c
  ;; d
  ;; e
  ;; f
  (define-key km [?f]    'font-lock-fontify-buffer)
  ;; g
  (define-key km [?g]    'goto-line)
  ;; h
  ;; i
  ;; j
  ;; k
  ;; l
  ;; m
  ;; n
  ;; o
  ;; p
  ;; q
  ;; r
  (define-key km [?r ?m]    'org-remember)
  (define-key km [?r ?c]    'org-remember-code-reading)
  (define-key km [?r ?t]    'org-remember-code-to-do)
  ;; s
  ;; t
  ;; timan
  (define-key km [?t ?K]    'timan-kitchen-timer)
  (define-key km [?t ?k]    'timan-kitchen-timer-with-insert)
  (define-key km [?t ?C]    'timan-kitchen-timer-cancel-all-timers)
  (define-key km [?t ?i]    'timan-insert-current-time)
  ;; u
  ;; v
  ;; w
  ;; x
  ;; y
  ;; z

  ;; A
  ;; B
  ;; C
  ;; D
  ;; E
  ;; F
  ;; G
  (define-key km [?G]    'googling)
  ;; H
  ;; I
  ;; J
  ;; K
  ;; L
  ;; M
  ;; N
  ;; O
  ;; P
  ;; Q
  ;; R
  ;; S
  ;; T
  ;; U
  ;; V
  ;; W
  ;; X
  ;; Y
  ;; Z

  (define-key km [?\C-c] 'save-buffers-kill-emacs)
  (define-key km [?\C-f] 'my-find-lib)
  (define-key km [?\C-t] 'excite-translate)

  (define-key km [?\M-g] 'my-git-status)

  (setq my-ctrl-z-map km)
  (global-set-key my-km-prefix km))

