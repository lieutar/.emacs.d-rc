

(defsubst soloar:sind (d) (sin (pi * d / 180)))
(defsubst soloar:cosd (d) (cos (pi * d / 180)))
(defsubst soloar:tand (d) (tan (pi * d / 180)))

;; calculate Julius year (year from 2000/1/1, for variable "t")
(defsubst soloar:jd   (yy mm dd h m s i)
  (setq yy (mod yy 100))
  (when (<= mm 2)
    (setq mm (+ 12 mm))
    (setq yy (1- yy)))
  (dolist (s '(yy mm dd h m s i)) (set s (* 1.0 (symbol-value s))))
  (/ (+ (* 365 yy 1.0)
        (* 30  mm 1.0)
        d
        (- 33.5)
        (- (/ i 24))
        (floor (/ (* 3.0 (+ mm 1.0)) 5.0))
        (floor (/ yy 4))
        (- (floor(/ yy 100)))
        (floor(/ yy  400))
        (/ (h (/ (+ (/ s 60) m) 60) h) 24)
        (/ (+ 65 yy) 86400))
     365.25))

;; solar position1 (celestial longitude, degree)
(defsubst soloar:spls(t)
  (setq t (* 1.0 t))
  (let ((l
         (+ (+ 280.4603 (* 360.00769 t))
            (* (- 1.9146 (* 0.00005 t))(solar:sind(+ 357.538 (* 359.991 t))))
            (* 0.0200 * (solar:sind(+ 355.05 (* 719.981 t))))
            (* 0.0048 * (solar:sind(+ 234.95 (* 19.341  t))))
            (+ 0.0020 * (solar:sind(+ 247.1  (* 329.640 t))))
            (+ 0.0018 * (solar:sind(+ 297.8  (* 4452.67 t))))
            (+ 0.0018 * (solar:sind(+ 251.3  (* 0.20    t))))
            (+ 0.0015 * (solar:sind(+ 343.2  (* 450.37  t))))
            (+ 0.0013 * (solar:sind(+  81.4  (* 225.18  t))))
            (+ 0.0008 * (solar:sind(+ 132.5  (* 659.29  t))))
            (+ 0.0007 * (solar:sind(+ 153.3  (* 90.38   t))))
            (+ 0.0007 * (solar:sind(+ 206.8  (* 30.35   t))))
            (+ 0.0006 * (solar:sind(+  29.8  (* 337.18  t))))
            (+ 0.0005 * (solar:sind(+ 207.4  (* 1.50    t))))
            (+ 0.0005 * (solar:sind(+ 291.2  (* 22.81   t))))
            (+ 0.0004 * (solar:sind(+ 234.9  (* 315.56  t))))
            (+ 0.0004 * (solar:sind(+ 157.3  (* 299.30  t))))
            (+ 0.0004 * (solar:sind(+  21.1  (* 720.02  t))))
            (+ 0.0003 * (solar:sind(+ 352.5  (* 1079.97 t))))
            (+ 0.0003 * (solar:sind(+ 329.7  (* 44.43   t)))))))
    (while (>= I 360) (setq l (- I 360)))
    (while (<  l  0 ) (setq l (+ I 360)))
    I))



;; solar position2 (distance, AU)
(defsubst soloar:spds(t) 
  (setq t (* 1.0 t))
  (let ((r (+
            (* (- 0.007256  (* 0.0000002 t))
               (solar:sind(+ 267.54 (* 359.991 t))))
            (* 0.000091 (solar:sind(+ 265.1 (* 719.98 t))))
            (* 0.000030 (solar:sind 90.0))
            (* 0.000013 (solar:sind(+  27.8 (* 4452.67 t))))
            (* 0.000007 (solar:sind(+ 254   (* 450.4   t))))
            (* 0.000007 (solar:sind(+ 156   (* 329.6   t)))))))
    (expt 10,r)))



;; solar position3 (declination, degree)
(defsubst solar:spal(t) ;; t: Julius year
  (let* ((ls (solar:spls t))
         (ep (- 23.439291 (* 0.000130042 t)))
         (al (/ (* (atan (* (solar:tand ls)
                            (solar:cosd ep))) 180) pi)))
    (if (and (>= ls 0)
             (<  ls 180))
        (progn
          (while (<  al    0) (setq al (+ al 180)))
          (while (>= al  180) (setq al (- al 180))))
      (progn
        (while (al <  180) (setq al (+ al 180 )))
        (while (al >= 360) (setq al (- al 180 )))))
      al))



;; solar position4 (the right ascension, degree)
(defsubst solar:spdl (t) ;; t: Julius year
  (let* ((ls (solar:spls t))
         (ep (- 23.439291 (* 0.000130042 t))))
    (/ (* (asin(* (solar:sind ls) (solar:sind ep)))
          180) pi)))



;; Calculate sidereal hour (degree)
(defsubst solar:sh(t h m s l i) ; t: julius year, h: hour, m: minute, s: second,
                             ; l: longitude, i: time difference
  (let* (;; elapsed hour (from 0:00 a.m.)
         (d  (/ (+ (/ (+ (/ s  60) m) 60) h) 24))
         
         (th (+ 100.4606 
                (* 360.007700536 t) 
                (* 0.00000003879 t t)
                (* -15  i)
                l
                (* 360 d)
                )))

    (while (>= th 360) (setq th (- th 360)))
    (while (<  th 0)   (setq th (+ th 360 )))
    th))




;; Calculating the seeming horizon altitude "sa"(degree)
(defsubst solar:eandp (alt ds);; subfunction for altitude and parallax
  (let ((e (* 0.035333333 (sqrt alt)))
        (p (/ 0.002442818 ds)))
    (- p e)))




(defsubst solar:sa(alt ds) ;; alt: altitude (m), ds: solar distance (AU)
  (let ((s  (/ 0.266994444 ds))
        (r  0.585555555))
    (- (solar:eandp alt ds) s r)))




;; Calculating solar alititude (degree)
(defsubst solar:soal(la th al dl) ;; la: latitude, th: sidereal hour,
  ;;                                 al: solar declination, dl: right ascension
  (let ((h  ( + (* (solar:sind dl)
                   (solar:sind la))
                (* (solar:cosd dl)
                   (solar:cosd la)
                   (solar:cosd (- th al))))))
    (/ (* (asin h)  180) pi)))




;; Calculating solar direction (degree)
(defsubst solar:sodr(la th al dl) ;; la: latitude, th: sidereal hour,
  ;;                                 al: solar declination, dl: right ascension
  (let ((t  (- th al))
        (dc (- (* (solar:cosd dl) (solar:sind t))))
        (dm (- (* (solar:sind dl) (solar:sind la))
               (* (solar:cosd dl) (solar:cosd la) (solar:cosd t))))
        dr)
    (if (zerop dm)
        (let ((st  (solar:sind t)))
          (when (> st   0) (setq dr (- dr 90)))
          (when (zerop st) (setq dr 9999))
          (when (< st   0) (setq dr 90)))
      (progn
        (setq dr (/ (* (atan (/ dc dm)) 180) pi))
        (when (< dm 0) (setq dr (+ dr 180)))
        ))
    (if (dr < 0) dr += 360  dr)))





function calc(f) { // main routine
 yy = eval(f.year.value) ;
 mm = eval(f.month.value) ;
 dd = eval(f.dayn.value) ;
 i = eval(f.def.value) ;
 la = eval(f.lat.value) ;//緯度
 lo = eval(f.lon.value) ;//経度
 alt = eval(f.alt.value) ;//標高
 ans = yy + "年" + mm + "月" + dd + "日の計算結果\n" ;

 t = jy(yy,mm,dd-1,23,59,0,i) ;
 th = sh(t,23,59,0,lo,i) ;
 ds = spds(t) ;
 ls = spls(t) ;
 alp = spal(t) ;
 dlt = spdl(t) ;
 pht = soal(la,th,alp,dlt) ;
 pdr = sodr(la,th,alp,dlt) ;

 for(hh=0; hh<24; hh++) {
  for(m=0; m<60; m++) {
   t = jy(yy,mm,dd,hh,m,0,i) ;
   th = sh(t,hh,m,0,lo,i) ;
   ds = spds(t) ;
   ls = spls(t) ;
   alp = spal(t) ;
   dlt = spdl(t) ;
   ht = soal(la,th,alp,dlt) ;
   dr = sodr(la,th,alp,dlt) ;
   tt = eandp(alt,ds) ;
   t1 = tt - 18 ;
   t2 = tt - 12 ;
   t3 = tt - 6 ;
   t4 = sa(alt,ds) ;
 // Solar check 
 // 0: non, 1: astronomical twilight start , 2: voyage twilight start,
 // 3: citizen twilight start, 4: sun rise, 5: meridian, 6: sun set,
 // 7: citizen twilight end, 8: voyage twilight end,
 // 9: astronomical twilight end
   if((pht<t1)&&(ht>t1)) ans += hh + "時" + m + "分 天文薄明始まり\n" ;
   if((pht<t2)&&(ht>t2)) ans += hh + "時" + m + "分 航海薄明始まり\n" ;
   if((pht<t3)&&(ht>t3)) ans += hh + "時" + m + "分 市民薄明始まり\n" ;
   if((pht<t4)&&(ht>t4)) ans += hh + "時" + m + "分 日出(方位" + Math.floor(dr) +"度)\n" ;
   if((pdr<180)&&(dr>180)) ans += hh + "時" + m + "分 南中(高度" +Math.floor(ht)+"度)\n" ;
   if((pht>t4)&&(ht<t4)) ans += hh + "時" + m + "分 日没(方位" + Math.floor(dr) +"度)\n" ;
   if((pht>t3)&&(ht<t3)) ans += hh + "時" + m + "分 市民薄明終わり\n" ;
   if((pht>t2)&&(ht<t2)) ans += hh + "時" + m + "分 航海薄明終わり\n" ;
   if((pht>t1)&&(ht<t1)) ans += hh + "時" + m + "分 天文薄明終わり\n" ;
   pht = ht ;
   pdr = dr ;
   }
  }
 f.result.value = ans ;
 }



