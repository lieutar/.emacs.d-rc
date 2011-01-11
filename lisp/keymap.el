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
  (define-key km [?s]       'sr-speedbar-toggle)
  ;; t
  ;; timan
  (define-key km [?t ?K] 'timan-kitchen-timer)
  (define-key km [?t ?k] 'timan-kitchen-timer-with-insert)
  (define-key km [?t ?C] 'timan-kitchen-timer-cancel-all-timers)
  (define-key km [?t ?i] 'timan-insert-current-time)
  (define-key km [?t ?t] 'timan-daily-resources)
  ;; u
  ;; v
  ;; w
  ;; x
  ;; y
  ;; z
  (define-key km [?z]       'global-framov-mode)

  ;; !
  ;; "
  ;; #
  ;; $
  ;; %
  ;; &
  ;; '
  ;; (
  ;; )
  ;; *
  ;; +
  ;; ,
  ;; -
  ;; .
  ;; /
  

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
  (define-key km [?M ?t] 'migemo-toggle-isearch-enable)
  ;; N
  ;; O
  ;; P
  ;; Q
  ;; R
  (define-key km [?R] 'find-git-find-repos)
  ;; S
  ;; T
  (define-key km [?T] 'toggle-truncate-lines)
  ;; U
  ;; V
  ;; W
  ;; X
  ;; Y
  ;; Z

  ;; C-a
  (define-key km [?\C-a ?\C-a] 'anything-execute-anything-command)
  (define-key km [?\C-a ?\C-s] 'my-anything-c-yas-complete)
  (define-key km [?\C-a ?\C-q] 'anything-quicklaunch)

  ;; C-b
  (define-key km [?\C-b] 'anything-buffers+)

  ;; C-c
  (define-key km [?\C-c] 'save-buffers-kill-emacs)
  ;; C-d
  ;; C-e
  ;; C-f
  (define-key km [?\C-f] 'my-anything-open)
  ;; C-g
  ;; C-h
  ;; C-i
  ;; C-j
  ;; C-k
  ;; C-l
  ;; C-m
  ;; C-n
  ;; C-o
  ;; C-p
  ;; C-q
  ;; C-r
  ;; C-s
  ;; C-t
  (define-key km [?\C-t] 'excite-translate)
  ;; C-u
  ;; C-v
  ;; C-w
  ;; C-x
  ;; C-y
  ;; C-z

  ;; M-a
  ;; M-b
  ;; M-c
  ;; M-d
  ;; M-e
  ;; M-f
  (define-key km [?\M-f] 'my-find-lib)
  ;; M-g
  (define-key km [?\M-g] 'my-git-status)
  ;; M-h
  ;; M-i
  ;; M-j
  ;; M-k
  ;; M-l
  ;; M-m
  ;; M-n
  ;; M-o
  ;; M-p
  ;; M-q
  ;; M-r
  ;; M-s
  ;; M-t
  ;; M-u
  ;; M-v
  ;; M-w
  ;; M-x
  ;; M-y
  ;; M-z

  (setq my-ctrl-z-map          km)
  (global-set-key my-km-prefix km)
  )

