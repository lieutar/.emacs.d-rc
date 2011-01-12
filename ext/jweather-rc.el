(rc-ext
 :name 'jweather
 :load 'jweather
 :init (lambda ()
         (setq jweather:image-magick:convert "/usr/bin/convert")
         (setq jweather:weather-chart:pixel-size 200)

         (setq jweather:default-position
               (acman-get "*persona* formal pref"))))

