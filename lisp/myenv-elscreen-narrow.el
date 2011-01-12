(elsx:set-environment
 '(0 main)
 '((main
    :focus     agenda
    :composition
    ((|)
     (:name main :size 84)
     ((-)
      (:name tw-home
       :init (lambda () (twit)))
      (:name tw-mentions
       :init (lambda () (twittering-visit-timeline ":mentions"))))))

   (default
     :composition
     ((|)
      (:size 84  :name main-1)
      (:size nil :name main-2))
     ))
 )

