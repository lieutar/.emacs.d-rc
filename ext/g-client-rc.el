(rc-ext
 :path "g-client"
 :load (lambda () (load-library "g"))
 :autoload
 '(greader-add-label                  greader-feed-list
   greader-find-feeds                 greader-preferences
   greader-reading-list               greader-star
   greader-subscribe-feed             greader-tag-feed
   greader-title-feed                 greader-unsubscribe-feed
   greader-untag-feed
   gcal-add-event                     gcal-delete-event
   gcal-read-event                    gcal-show-calendar
   gcal-show-event
   gblogger-atom-display              gblogger-blog
   gblogger-edit-entry                gblogger-new-entry
   gblogger-post-entry                gblogger-publish
   gblogger-put-entry)

 :get
 (lambda () (browse-url "http://www.emacswiki.org/emacs/GoogleClient"))

 :init
 (lambda ()
   (let ((mail (acman-get-property "*about*" "*me*" "email")))
     (setq g-user-email        mail)
     (setq gcal-user-email     mail)
     (setq gblogger-user-email mail)
     )
   ))

