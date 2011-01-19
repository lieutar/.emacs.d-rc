;;; solar.el --- 

;; Copyright (C) 2011  U-TreeFrog\lieutar

;; Author: U-TreeFrog\lieutar <lieutar@TreeFrog>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:


;;;
;;; このプログラムは、東海大学開発工学部星研究室内で公開されている
;;; javascript アプリケーションを emacs-lisp 化したものです
;;;

;;;
;;; SEE ALSO
;;;
;;; (browse-url "http://www.fb.u-tokai.ac.jp/WWW/hoshi/env/solar-j.html")
;;;

(defconst solar:city-positions
  '((Naha          26.2167  127.6667    0.0  +9) ;; 那覇
    (Kagoshima     31.3600  130.3300    0.0  +9) ;; 鹿児島
    (Fukuoka       33.3500  130.2300    0.0  +9) ;; 福岡
    (Koushi        33.3300  133.3100    0.0  +9) ;; 高知
    (Hiroshima     34.2300  132.2700    0.0  +9) ;; 広島
    (Osaka         34.4100  135.2900    0.0  +9) ;; 大阪
    (Kyoto         35.0000  135.4600    0.0  +9) ;; 京都
    (Nagoya        35.1100  136.5400    0.0  +9) ;; 名古屋
    (Fukuoka       34.5800  138.2300    0.0  +9) ;; 静岡
    (Tokyo         35.6544  139.7447    0.0  +9) ;; 東京
    (Kanazawa      36.3300  136.3900    0.0  +9) ;; 金沢
    (Nagano        36.3900  138.1100    0.0  +9) ;; 長野
    (Fukushima     37.4500  140.2800    0.0  +9) ;; 福島
    (Akita         39.4300  140.0600    0.0  +9) ;; 秋田
    (Aomori        40.4900  140.4400    0.0  +9) ;; 青森
    (Sapporo       43.0300  141.2100    0.0  +9) ;; 札幌
    (London        51.3000   -0.1000    0.0   0) ;; ロンドン
    (Capetown     -33.5700   18.2700    0.0  +2) ;; ケープタウン
    (Sidney       -33.5300  151.1000    0.0 +10) ;; シドニー
    (Beijing       39.5500  116.2600    0.0  +8) ;; ペキン
    (Seoul         37.3200  126.5800    0.0  +9) ;; ソウル
    (Singapore      1.1700  103.5100    0.0  +8) ;; シンガポール
    (Bangkok       13.4500  100.3200    0.0  +7) ;; バンコク
    (Moscow        55.4400   37.4200    0.0  +3) ;; モスクワ
    (Hersinki      60.1000   24.5600    0.0  +2) ;; ヘルシンキ
    (Athene        38.0000   23.4300    0.0  +2) ;; アテネ
    (Nairobi       -1.1700   36.5100    0.0  +3) ;; ナイロビ
    (Sanfrancisco  37.4500 -122.2600    0.0  -8) ;; サンフランシスコ
    (Wasington     38.5400  -77.0000    0.0  -5) ;; ワシントン
    (Sanpaolo     -23.3200  -46.3800    0.0  -3) ;; サンパウロ
    (Rima         -12.0600  -77.0200    0.0  -5) ;; リマ
    (Showwa-base  -69.0083   39.5917    0.0  +3) ;; 南極昭和基地
    ))


(defun solar:add-city (name latitude longitude altitude tz)
  (add-to-list 'solar:city-positions
               (list name latitude longitude altitude tz)))





;; Math.PI 3.141592653589793
;; pi      3.141592653589793 ;;

(defsubst solar:sind (d) (sin (/ (* pi  d) 180)))
;; sind(10)        0.17364817766693033
;; (solar:sind 10) 0.17364817766693033 ;;


(defsubst solar:cosd (d) (cos (/ (* pi  d) 180)))
;; cosd(10)        0.984807753012208
;; (solar:cosd 10) 0.984807753012208 ;;

(defsubst solar:tand (d) (tan (/ (* pi  d) 180)))
;; tand(10)        0.17632698070846495
;; (solar:tand 10) 0.17632698070846495 ;;



;; calculate Julius year (year from 2000/1/1, for variable "tt")
(defsubst solar:julius-year (yy ;; gregorian year
                             mm ;; gregorian month
                             dd ;; gregorian date
                             h  ;; hour
                             m  ;; minutes
                             s  ;; seconds
                             i  ;; timezone
                             )

  ;; yy -= 2000 ;
  (setq yy (mod yy 100))


  ;;if(mm <= 2) {
  ;;   mm += 12 ;
  ;;   yy-- ; 
  ;;}
  (when (<= mm 2)
    (setq mm (+ 12 mm))
    (setq yy (1- yy)))

  (dolist (sym '(yy mm dd h m s i)) (set sym (* 1.0 (symbol-value sym))))


  ;; k = 
  (let ((k (+
            ;; 365 * yy
            (* 365.0 yy)

            ;;  + 30 * mm
            (* 30.0  mm)

            ;;  + dd
            dd

            ;;  - 33.5
            (- 33.5)

            ;;  - i / 24
            (- (/ i 24))
             
            ;; + Math.floor(3 * (mm + 1) / 5)
            (floor (/ (* 3.0 (+ mm 1.0)) 5.0))

            ;; + Math.floor(yy / 4)
            (floor (/ yy 4.0))

            ;; - Math.floor(yy / 100)
            (- (floor(/ yy 100.0)))

            ;; + Math.floor(yy / 400)
            (floor(/ yy  400.0))

            ;; + ((s / 60 + m) / 60 + h) / 24 ; // plus time
            (/ (+ (/ (+ (/ s 60) m) 60.0) h) 24)

            ;; + (65 + yy) / 86400 ; // plus delta T
            (/ (+ 65 yy) 86400))))

    ;; return k / 365.25 ;
    (/ k 365.25)))

;; jy(2005,12,22,10,59,59,9)                  5.972621492128679
;; (solar:julius-year 2005 12 22 10 59 59 9)  5.973874439120846



;; jy(2011,1,1,12,0,0,9)                     10.999315537303216
;; (solar:julius-year 2011 1 1 12 0 0 9)     10.999660145258195





;; solar position1 (celestial longitude, degree)
(defsubst solar:spls(tt)
  (setq tt (* 1.0 tt))
  ;;   var l =
  (let ((l
        ;;     280.4603 + 360.00769 * t 
         (+ 280.4603
            (* 360.00769 tt)
            ;;--

            ;; + (1.9146 - 0.00005 * t) * sind(357.538 + 359.991 * t)
            (* (- 1.9146 (* 0.00005 tt))
               (solar:sind(+ 357.538 (* 359.991 tt))))
            ;;--

            ;;  + 0.0200 * sind(355.05 +  719.981 * t)
            (* 0.0200 (solar:sind(+ 355.05 (* 719.981 tt))))
            ;;--

            ;; + 0.0048 * sind(234.95 +   19.341 * t)
            (* 0.0048 (solar:sind(+ 234.95 (* 19.341  tt))))
            ;;--

            ;; + 0.0020 * sind(247.1  +  329.640 * t)
            (* 0.0020 (solar:sind(+ 247.1  (* 329.640 tt))))
            ;;

            ;; + 0.0018 * sind(297.8  + 4452.67  * t)
            (* 0.0018 (solar:sind(+ 297.8  (* 4452.67 tt))))
            ;;

            ;; + 0.0018 * sind(251.3  +    0.20  * t)
            (* 0.0018 (solar:sind(+ 251.3  (* 0.20    tt))))
            ;;

            ;; + 0.0015 * sind(343.2  +  450.37  * t)
            (* 0.0015 (solar:sind(+ 343.2  (* 450.37  tt))))
            ;;

            ;; + 0.0013 * sind( 81.4  +  225.18  * t)
            (* 0.0013 (solar:sind(+  81.4  (* 225.18  tt))))
            ;;

            ;; + 0.0008 * sind(132.5  +  659.29  * t)
            (* 0.0008 (solar:sind(+ 132.5  (* 659.29  tt))))
            ;;

            ;; + 0.0007 * sind(153.3  +   90.38  * t)
            (* 0.0007 (solar:sind(+ 153.3  (* 90.38   tt))))
            ;;

            ;; + 0.0007 * sind(206.8  +   30.35  * t)
            (* 0.0007 (solar:sind(+ 206.8  (* 30.35   tt))))
            ;;

            ;; + 0.0006 * sind( 29.8  +  337.18  * t)
            (* 0.0006 (solar:sind(+  29.8  (* 337.18  tt))))
            ;;

            ;; + 0.0005 * sind(207.4  +    1.50  * t)
            (* 0.0005 (solar:sind(+ 207.4  (* 1.50    tt))))
            ;;

            ;; + 0.0005 * sind(291.2  +   22.81  * t)
            (* 0.0005 (solar:sind(+ 291.2  (* 22.81   tt))))
            ;;

            ;; + 0.0004 * sind(234.9  +  315.56  * t)
            (* 0.0004 (solar:sind(+ 234.9  (* 315.56  tt))))
            ;;

            ;; + 0.0004 * sind(157.3  +  299.30  * t)
            (* 0.0004 (solar:sind(+ 157.3  (* 299.30  tt))))
            ;;

            ;; + 0.0004 * sind( 21.1  +  720.02  * t)
            (* 0.0004 (solar:sind(+  21.1  (* 720.02  tt))))
            ;;

            ;; + 0.0003 * sind(352.5  + 1079.97  * t)
            (* 0.0003 (solar:sind(+ 352.5  (* 1079.97 tt))))
            ;;

            ;; + 0.0003 * sind(329.7  +   44.43  * t) ;
            (* 0.0003 (solar:sind(+ 329.7  (* 44.43   tt)))))))
    ;;;;;;;;;;;

    (while (>= l 360) (setq l (- l 360)))
    (while (<  l  0 ) (setq l (+ l 360)))
    l))
;; spls(10)        280.45112364671695
;; (solar:spls 10) 280.4511236467174



;; solar position2 (distance, AU)
(defsubst solar:spds(tt) 
  (setq tt (* 1.0 tt))
  (let ((r (+
            (* (- 0.007256  (* 0.0000002 tt))
               (solar:sind(+ 267.54 (* 359.991 tt))))
            (* 0.000091 (solar:sind(+ 265.1 (* 719.98 tt))))
            (* 0.000030 (solar:sind 90.0))
            (* 0.000013 (solar:sind(+  27.8 (* 4452.67 tt))))
            (* 0.000007 (solar:sind(+ 254   (* 450.4   tt))))
            (* 0.000007 (solar:sind(+ 156   (* 329.6   tt)))))))
    (expt 10 r)))
;; spds(10)        0.9832924873180311
;; (solar:spds 10) 0.9832924873180311 ;;




;; solar position3 (declination, degree)
(defsubst solar:spal(tt) ;; tt: Julius year
  (let* ((ls (solar:spls tt))
         (ep (- 23.439291 (* 0.000130042 tt)))
         (al (/ (* (atan (* (solar:tand ls)
                            (solar:cosd ep))) 180) pi)))
    (if (and (>= ls 0)
             (<  ls 180))
        (progn
          (while (<  al    0) (setq al (+ al 180)))
          (while (>= al  180) (setq al (- al 180))))
      (progn
        (while (<  al 180) (setq al (+ al 180 )))
        (while (>= al 360) (setq al (- al 180 )))))
      al))
;; spal(10)        281.3674820255876
;; (solar:spal 10) 279.43019008800684




;; solar position4 (the right ascension, degree)
(defsubst solar:spdl (tt) ;; tt: Julius year
  ;;     ls = spls(t) ;
  (let* ((ls (solar:spls tt))
         ;; ep = 23.439291 - 0.000130042 * t ;
         (ep (- 23.439291 (* 0.000130042 tt))))

    ;; dl = Math.asin(sind(ls) * sind(ep)) * 180 / Math.PI ;
    ;; return dl ;
    (/ (* (asin(* (solar:sind ls) (solar:sind ep)))
          180) pi)))
;; spdl(10)        -23.02654506652691
;; (solar:spdl 10) -23.15481707574317




;; Calculate sidereal hour (degree)
(defsubst solar:sh(
                   tt  ; tt: julius year,
                   h  ; h: hour,
                   m  ; m: minute,
                   s  ; s: second,
                   l  ; l: longitude,
                   i  ; i: time difference
                   )
  (let* (;; elapsed hour (from 0:00 a.m.)
         (d  (/ (+ (/ (+ (/ s  60) m) 60) h) 24))
         
         (th (+ 100.4606 
                (* 360.007700536 tt) 
                (* 0.00000003879 tt tt)
                (* -15  i)
                l
                (* 360 d)
                )))

    (while (>= th 360) (setq th (- th 360)))
    (while (<  th 0)   (setq th (+ th 360 )))
    th))

;; sh(10,10,10,10,10,10)        320.5376092389997
;; (solar:sh 10 10 10 10 10 10) 320.5376092389997 ;;



;; Calculating the seeming horizon altitude "sa"(degree)
(defsubst solar:eandp (alt
                       ds);; subfunction for altitude and parallax
  (let ((e (* 0.035333333 (sqrt alt)))
        (p (/ 0.002442818 ds)))
    (- p e)))
;; eandp(10,10)        -0.1114895278051902
;; (solar:eandp 10 10) -0.1114895278051902 ;;




(defsubst solar:sa(alt ds) ;; alt: altitude (m), ds: solar distance (AU)
  (let ((s  (/ 0.266994444 ds))
        (r  0.585555555))
    (- (solar:eandp alt ds) s r)))
;; sa(10,10)        -0.7237445272051902
;; (solar:sa 10 10) -0.7237445272051902 ;;




;; Calculating solar alititude (degree)
(defsubst solar:altitude(la th al dl) ;; la: latitude, th: sidereal hour,
  ;;                                 al: solar declination, dl: right ascension
  (let ((h  ( + (* (solar:sind dl)
                   (solar:sind la))
                (* (solar:cosd dl)
                   (solar:cosd la)
                   (solar:cosd (- th al))))))
    (/ (* (asin h)  180) pi)))
;; soal(10,10,10,10)            89.99999914622636
;; (solar:altitude 10 10 10 10) 89.99999914622636 ;;





;; Calculating solar direction (degree)
(defsubst solar:direction(la th al dl) ;; la: latitude, th: sidereal hour,
  ;;                                 al: solar declination, dl: right ascension
  (let* ((tt (- th al))
         (dc (- (* (solar:cosd dl) (solar:sind tt))))
         (dm (- (* (solar:sind dl) (solar:sind la))
                (* (solar:cosd dl) (solar:cosd la) (solar:cosd tt))))
         dr)
    (if (zerop dm)
        (let ((st  (solar:sind tt)))
          (when (> st   0) (setq dr (- dr 90)))
          (when (zerop st) (setq dr 9999))
          (when (< st   0) (setq dr 90)))
      (progn
        (setq dr (/ (* (atan (/ dc dm)) 180) pi))
        (when (< dm 0) (setq dr (+ dr 180)))
        ))
    (if (< dr 0) (+ dr 360)  dr)))
;; sodr(10,10,10,10)        180
;; (solar:direction 10 10 10 10) 180.0 ;;




(defun solar:calc (&rest f)
  (let* ((now  (decode-time (current-time)))
         (yy   (or (plist-get f :year ) (nth 5 now)))
         (mm   (or (plist-get f :month) (nth 4 now)))
         (dd   (or (plist-get f :date)  (nth 3 now)))
         (city (plist-get f :city))
         i
         lo
         la
         alt

         ;; 返値用シンボル
         astronomical-twilight-1
         naval-twilight-1
         civil-twilight-1
         sunrize
         noon
         sunset
         civil-twilight-2
         naval-twilight-2
         astronomical-twilight-2
         sunrize-direction
         sunset-direction
         noon-altitude
         )

      (if city

          (let ((data (assq city solar:city-positions)))
            (unless data (error "Unknown city: %s" city))
            (setq i    (nth 4 data))  ;; UTCとの時差
            (setq lo   (nth 2 data))  ;; 経度
            (setq la   (nth 1 data))  ;; 緯度
            (setq alt  (nth 3 data))  ;; 標高
            )

        (progn
          (setq i    (plist-get f :tz))         ;; UTCとの時差
          (setq lo   (plist-get f :longitude))  ;; 経度
          (setq la   (plist-get f :latitude))   ;; 緯度
          (setq alt  (plist-get f :altitude))   ;; 標高
          ))



        (let* ((tt  (solar:julius-year yy mm (1- dd) 23 59 0 i))
               (th  (solar:sh tt 23 59 0 lo i))
               (ds  (solar:spds tt))
               (ls  (solar:spls tt))
               (alp (solar:spal tt))
               (dlt (solar:spdl tt))
               (pht (solar:altitude la th alp dlt))
               (pdr (solar:direction la th alp dlt)))

          ;; 24時間すべてチェックする
          (loop for hh from 0 to 23 do
                (loop for m from 0 to 59 do
                      (let* ((tt  (solar:julius-year  yy mm dd hh m 0 i))
                             (th  (solar:sh   tt hh  m 0 lo i))
                             (ds  (solar:spds tt))
                             (ls  (solar:spls tt))
                             (alp (solar:spal tt))
                             (dlt (solar:spdl tt))
                             (ht  (solar:altitude la th alp dlt))
                             (dr  (solar:direction la th alp dlt))
                             (ttt  (solar:eandp alt ds))
                             (t1  (- ttt 18.0))
                             (t2  (- ttt 12.0))
                             (t3  (- ttt 6.0))
                             (t4  (solar:sa alt ds))
                             (sym (cond
                                   ;; if((pht<t1)&&(ht>t1))
                                   ((and (< pht t1)(> ht t1))
                                   ;; ans += hh + "時" + m +
                                   ;; "分 天文薄明始まり\n" ;
                                    'astronomical-twilight-1)

                                   ;;if((pht<t2)&&(ht>t2))
                                   ((and (< pht t2)(> ht t2))
                                    ;; ans += hh + "時" + m +
                                    ;; "分 航海薄明始まり\n" ;
                                    'naval-twilight-1)

                                   ;; if((pht<t3)&&(ht>t3))
                                   ((and (< pht t3)(> ht t3))
                                    ;; ans += hh + "時" + m + 
                                    ;; "分 市民薄明始まり\n" ;
                                    'civil-twilight-1)

                                   ;; if((pht < t4) && (ht>t4))
                                   ((and (< pht t4)(> ht t4))
                                    ;; ans += hh + "時" + m +
                                    ;; "分 日出(方位" +
                                    ;; Math.floor(dr) +"度)\n" ;
                                    (setq sunrize-direction (floor dr))
                                    'sunrize)


                                   ;; if((pdr<180)&&(dr>180))
                                   ((and (< pdr 180)
                                         (>  dr 180))
                                   ;; ans += hh + "時" + m + 
                                   ;; "分 南中(高度" +
                                   ;; Math.floor(ht)+"度\n"
                                    (setq noon-altitude (flor ht))
                                    'noon)

                                   ;; if((pht > t4)&&(ht < t4))
                                   ((and (> pht t4)(< ht t4))
                                    ;;  ans += hh + "時" + m +
                                    ;; "分 日没(方位" + Math.floor(dr) +"度)\n" ;
                                    (setq sunset-direction (floor dr))
                                    'sunset)

                                   ;; if((pht>t3)&&(ht<t3))
                                   ((and (> pht t3)(< ht t3))
                                    ;;  ans += hh + "時" + m + 
                                    ;; "分 市民薄明終わり\n" ;
                                    'civil-twilight-2)

                                   ;; if((pht>t2)&&(ht<t2))
                                   ((and (> pht t2)(< ht t2))
                                    ;;  ans += hh + "時" + m + 
                                    ;; "分 航海薄明終わり\n" ;
                                    'naval-twilight-2)

                                   ;; if((pht>t1)&&(ht<t1))
                                   ((and (> pht t1)(< ht t1))
                                    ;;  ans += hh + "時" + m +
                                    ;;  "分 天文薄明終わり\n" ;
                                    'astronomical-twilight-2)
                                   )))
                        (when sym (set sym (cons hh m)))
                        (setq pht ht)
                        (setq pdr dr)))))
        (list
         astronomical-twilight-1 ;; 天文薄明開始
         naval-twilight-1        ;; 航海薄明開始
         civil-twilight-1        ;; 市民薄明開始
         sunrize                 ;; 日の出
     noon                    ;; 南中
     sunset                  ;; 日の入
     civil-twilight-2        ;; 市民薄明終了
     naval-twilight-2        ;; 航海薄明終了
     astronomical-twilight-2 ;; 天文薄明終了
     noon-altitude             ;; 南中高度 (°)
     sunrize-direction       ;; 日の出の方位 (°)
     sunset-direction        ;; 日の入りの方位 (°)
     )))

;;(solar:calc :city 'Tokyo)

(provide 'solar)
;;; solar.el ends here



(defsubst solar:calc-at-time (la lo alt yy mm dd hh m i)
  (let* ((tt  (solar:julius-year  yy mm dd hh m 0 i))
         (th  (solar:sh   tt hh  m 0 lo i))
         (ds  (solar:spds tt))
         (ls  (solar:spls tt))
         (alp (solar:spal tt))
         (dlt (solar:spdl tt))
         (ht  (solar:altitude  la th alp dlt))
         (dr  (solar:direction la th alp dlt))
         (ttt (solar:eandp alt ds))
         (t1  (- ttt 18.0))
         (t2  (- ttt 12.0))
         (t3  (- ttt 6.0))
         (t4  (solar:sa alt ds)))
    (dolist (sym '(tt th ds ls alp dlt ht dr ttt t1 t2 t3 t4))
      (insert (format "\n;; % 4s % 4s" sym (symbol-value sym))))
    (insert "\n")))

;; (solar:calc-at-time 26.2167 127.6667 0 2011 1 1  5 55 9)
;; (solar:calc-at-time 26.2167 127.6667 0 2011 1 1 12 33 9)
;; (solar:calc-at-time 26.2167 127.6667 0 2011 1 1 19 11 9)

