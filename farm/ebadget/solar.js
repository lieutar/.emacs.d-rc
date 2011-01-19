


// sin function using degree
 function sind(d) {
   return Math.sin(d*Math.PI/180) ; }
 // cos function using degree
 function cosd(d) {
   return Math.cos(d*Math.PI/180) ; }
 // tan function using degree
 function tand(d) {
   return Math.tan(d*Math.PI/180) ; }
 // calculate Julius year (year from 2000/1/1, for variable "t")
 function jy(yy,mm,dd,h,m,s,i) { // yy/mm/dd h:m:s, i: time difference
   yy -= 2000 ;
   if(mm <= 2) {
    mm += 12 ;
    yy-- ; }
   k = 365 * yy + 30 * mm + dd - 33.5 - i / 24 + Math.floor(3 * (mm + 1) / 5) 
     + Math.floor(yy / 4) - Math.floor(yy / 100) + Math.floor(yy / 400);
   k += ((s / 60 + m) / 60 + h) / 24 ; // plus time
   k += (65 + yy) / 86400 ; // plus delta T
   return k / 365.25 ;
   }
 // solar position1 (celestial longitude, degree)
 function spls(t) { // t: Julius year
  var l = 280.4603 + 360.00769 * t 
     + (1.9146 - 0.00005 * t) * sind(357.538 + 359.991 * t)
     + 0.0200 * sind(355.05 +  719.981 * t)
     + 0.0048 * sind(234.95 +   19.341 * t)
     + 0.0020 * sind(247.1  +  329.640 * t)

     + 0.0018 * sind(297.8  + 4452.67  * t)
     + 0.0018 * sind(251.3  +    0.20  * t)

     + 0.0015 * sind(343.2  +  450.37  * t)
     + 0.0013 * sind( 81.4  +  225.18  * t)
     + 0.0008 * sind(132.5  +  659.29  * t)
     + 0.0007 * sind(153.3  +   90.38  * t)
     + 0.0007 * sind(206.8  +   30.35  * t)
     + 0.0006 * sind( 29.8  +  337.18  * t)
     + 0.0005 * sind(207.4  +    1.50  * t)
     + 0.0005 * sind(291.2  +   22.81  * t)
     + 0.0004 * sind(234.9  +  315.56  * t)
     + 0.0004 * sind(157.3  +  299.30  * t)
     + 0.0004 * sind( 21.1  +  720.02  * t)
     + 0.0003 * sind(352.5  + 1079.97  * t)
     + 0.0003 * sind(329.7  +   44.43  * t) ;
  while(l >= 360) { l -= 360 ; }
  while(l < 0) { l += 360 ; }
  return l ;
  }
 // solar position2 (distance, AU)
 function spds(t) { // t: Julius year
   r = (0.007256 - 0.0000002 * t) * sind(267.54 + 359.991 * t)
     + 0.000091 * sind(265.1 +  719.98 * t)
     + 0.000030 * sind( 90.0)
     + 0.000013 * sind( 27.8 + 4452.67 * t)
     + 0.000007 * sind(254   +  450.4  * t)
     + 0.000007 * sind(156   +  329.6  * t);
   r = Math.pow(10,r) ;
   return r ;
   }
 // solar position3 (declination, degree)
 function spal(t) { // t: Julius year
   ls = spls(t) ;
   ep = 23.439291 - 0.000130042 * t ;
   al = Math.atan(tand(ls) * cosd(ep)) * 180 / Math.PI ;
   if((ls >= 0)&&(ls < 180)) {
     while(al < 0) { al += 180 ; }
     while(al >= 180) { al -= 180 ; } }
   else {
     while(al < 180) { al += 180 ; }
     while(al >= 360) { al -= 180 ; } }
   return al ;
   }
 // solar position4 (the right ascension, degree)
 function spdl(t) { // t: Julius year
   ls = spls(t) ;
   ep = 23.439291 - 0.000130042 * t ;
   dl = Math.asin(sind(ls) * sind(ep)) * 180 / Math.PI ;
   return dl ;
   }
 // Calculate sidereal hour (degree)
 function sh(t,h,m,s,l,i) { // t: julius year, h: hour, m: minute, s: second,
                            // l: longitude, i: time difference
   d = ((s / 60 + m) / 60 + h) / 24 ; // elapsed hour (from 0:00 a.m.)
   th = 100.4606 + 360.007700536 * t + 0.00000003879 * t * t - 15 * i ;
   th += l + 360 * d ;
   while(th >= 360) { th -= 360 ; }
   while(th < 0) { th += 360 ; }
   return th ;
   }
 // Calculating the seeming horizon altitude "sa"(degree)
 function eandp(alt,ds) { // subfunction for altitude and parallax
   e = 0.035333333 * Math.sqrt(alt) ;
   p = 0.002442818 / ds ;
   return p - e ;
   }
 function sa(alt,ds) { // alt: altitude (m), ds: solar distance (AU)
   s = 0.266994444 / ds ;
   r = 0.585555555 ;
   k = eandp(alt,ds) - s - r ;
   return k ;
   }
 // Calculating solar alititude (degree) {
 function soal(la,th,al,dl) { // la: latitude, th: sidereal hour,
                              // al: solar declination, dl: right ascension
   h = sind(dl) * sind(la) + cosd(dl) * cosd(la) * cosd(th - al) ;
   h = Math.asin(h) * 180 / Math.PI ;
   return h;
   }
 // Calculating solar direction (degree) {
 function sodr(la,th,al,dl) { // la: latitude, th: sidereal hour,
                              // al: solar declination, dl: right ascension
   t = th - al ;
   dc = - cosd(dl) * sind(t) ;
   dm = sind(dl) * sind(la) - cosd(dl) * cosd(la) * cosd(t) ;
   if(dm == 0) {
     st = sind(t) ;
     if(st > 0) dr = -90 ;
     if(st == 0) dr = 9999 ;
     if(st < 0) dr = 90 ;
     }
   else {
     dr = Math.atan(dc / dm) * 180 / Math.PI ;
     if(dm <0) dr += 180 ;
     }
   if(dr < 0) dr += 360 ;
   return dr ;
   }

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


function calc_at_time(lo,la,alt,yy,mm,dd,hh,m,i){
  var tt = jy(yy,mm,dd,hh,m,0,i) ;
  var th = sh(tt,hh,m,0,lo,i) ;
  var ds = spds(tt) ;
  var ls = spls(tt) ;
  var alp = spal(tt) ;
  var dlt = spdl(tt) ;
  var ht = soal(la,th,alp,dlt) ;
  var dr = sodr(la,th,alp,dlt) ;
  var ttt = eandp(alt,ds) ;
  var t1 = ttt - 18 ;
  var t2 = ttt - 12 ;
  var t3 = ttt - 6 ;
  var t4 = sa(alt,ds) ;
  return ";; " +
    ( "tt th ds ls alp dlt ht dr ttt t1 t2 t3 t4".split(/\s+/).map(
        function(sym){
          return sym + " " + eval("(" + sym + ")");
        }
      ).join("\n;; ") )+ "\n";
}




function calc2(la,lo,alt, yy,mm,dd,i) { // main routine
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
  return ans;
 }
