#!perl -w
#
# クリニカルパス->HTML
# Nowral
# 04/05/15
#
use File::Basename;
use Text::ParseWords;

# ファイルループ開始
foreach $oldargv (sort @ARGV) {
  next unless $oldargv=~/\.csv$/; # CSV限定
  print "-"x80, "\n", (fileparse($oldargv, ''))[0], "\n";
  open(IN, $oldargv);

  # クリニカルパス読込み
  undef $ttl; # タイトル
  undef @dat; # 時期名称
  undef $cls1; # 小分類
  undef $cls; # 大分類
  undef %ent; # 分類名称
  undef @tne; # 分類名称(逆引き)
  undef @pth; # パス
  undef @ord; # 項目リスト

  # 添字
  #     i
  #  +------>
  #  |
  #j |
  #  |
  #  v
  # i:日付
  # j:項目分類
  # h:同一分類中の項目

  $j = -1;
  while(<IN>) {
    chomp;

    # 文字種統一
    @ed = quotewords(",", 0, $_);
    next unless @ed;
    for($i=0; $i<=$#ed; ++$i) {
      $ed[$i] =~ tr/,/、/;
      $ed[$i] =~ tr/　//d;
      $ed[$i] =~ tr/（）/\(\)/;
      $ed[$i] =~ tr/０-９ａ-ｚＡ-Ｚ/0-9a-zA-Z/; # 半角英数
    }
    $ed1 = shift @ed;
    
    # タイトル行<必須
    unless(defined $ttl) {
      next unless $ed1; # ??? タイトルが2つ目以降のセルにある場合
      $ttl = $ed1;
      print "$ttl\n\n";
      next;
    }

    # 項目行
    if($ed1) { # 大分類
      $cls = $ed1;
      $cls1 = $ed1;
    }
    $ed1 = shift @ed;
    
    # 時期行<必須
    unless(defined @dat) {
      @dat = @ed;
      print "\t", join("\t", @dat), "\n";
      next;
    }

    if($ed1) { # 小分類
      $cls = "$cls1\t$ed1";
    }
    unless(exists $ent{$cls}) { # 初見の分類?
      ++$j;
      $ent{$cls} = $j;
      $tne[$j] = $cls;
      undef @{$pth[$j]};
    }
    
    # ケア項目追加
    for($i=0; $i<=$#dat; ++$i) {
      $ed1 = shift @ed;
      next unless $ed1;
      if(defined $pth[$j][$i]) {
        $pth[$j][$i] .= "\t" . $ed1;
      }
      else {
        $pth[$j][$i] = $ed1;
      }
      last unless @ed;
    }
  }
  close(IN);
  
  # 番号置換
  for($j=0; $j<=$#tne; ++$j) {
    undef @{$ord[$j]};
    $ord[$j][0] = ""; # NOP
    for($i=0; $i<=$#dat; ++$i) {
      next unless $pth[$j][$i];
      undef @ed;
      foreach $ed1 (split("\t", $pth[$j][$i])) {
        for($h=1; $h<=$#{$ord[$j]}; ++$h) {
          last if($ord[$j][$h] eq $ed1);
        }
        push(@{$ord[$j]}, $ed1) if($h>$#{$ord[$j]});
        push(@ed, $h);
      }
      $pth[$j][$i] = join("\t", sort{$a<=>$b} @ed);
    }
    printf "%3d %s (%d)\n", $j+1, $tne[$j], $#{$ord[$j]};
  }
  
  # 出力ファイル準備
  $newargv = $oldargv;
  $newargv =~ s/\.csv$/\.html/;
  open(OUT, ">$newargv") || die "Couldn't open $newargv : $^E";
  MacPerl::SetFileInfo('MOSS', 'TEXT', $newargv);
  
  # ヘッダ出力
  print OUT <<END_OF_HEADER;
<html>
<head>
  <title>$ttl</title>
  <meta name="generator" content="CPCSV2HTML">
  <meta http-equiv="content-type" content="text/html; charset=shift_jis">
<script language="javascript">
<!--
function msg(str) {
  status = str;
}
//-->
</script>
</head>
<body bgcolor="#FFFFFF">
<h2><i>$ttl</i></h2>
<p>　</p>
<table border="0" cellspacing="1" cellpadding="3">
END_OF_HEADER

# 時期行出力
print OUT "\t<tr>\n";
print OUT "\t\t<td></td>\n";
print OUT "\t\t<td></td>\n";
foreach (@dat) {
  print OUT "\t\t<td><center>$_</center></td>\n";
}
print OUT "\t</tr>\n";

# 内容出力
$cls1 = "";
$loe = 0;
for($j=0; $j<=$#tne; ++$j) {
# 分類名称
  ($ed1, $cls) = split("\t", $tne[$j]);
  if($cls) {
    if($cls1 ne $ed1) {
      $cls1 = $ed1;
      for($j2=$j+1; $j2<=$#tne; ++$j2) {
        $ed1 = (split("\t", $tne[$j2]))[0];
        last unless $ed1 eq $cls1;
      }
      ++$loe;
      print OUT "\t<tr", $loe%2 ? " bgcolor=\"#CCCCFF\"" : " bgcolor=\"#EEEEEE\"", ">\n";
      print OUT "\t\t<td bgcolor=\"#000000\" valign=\"top\" rowspan=\"", $j2-$j, "\"><font color=\"#FFFFFF\">$cls1</font></td>\n";
    }
    else {
      print OUT "\t<tr", $loe%2 ? " bgcolor=\"#CCCCFF\"" : " bgcolor=\"#EEEEEE\"", ">\n";
    }
    print OUT "\t\t<td bgcolor=\"#000000\" valign=\"top\"><font color=\"#FFFFFF\">$cls</font></td>\n";
  }
  else {
    ++$loe;
    print OUT "\t<tr", $loe%2 ? " bgcolor=\"#CCCCFF\"" : " bgcolor=\"#EEEEEE\"", ">\n";
    print OUT "\t\t<td bgcolor=\"#000000\" valign=\"top\" colspan=\"2\"><font color=\"#FFFFFF\">$ed1</font></td>\n";
  }

# 項目書出し
  for($i=0; $i<=$#dat; ++$i) {
    unless($pth[$j][$i]) {
      print OUT "\t\t<td onMouseOver=\"msg(\'$tne[$j], $dat[$i]\')\"></td>\n";
      next;
    }
    @ed = split("\t", $pth[$j][$i]);
    print OUT "\t\t<td valign=\"top\" onMouseOver=\"msg(\'$tne[$j], $dat[$i]\')\">\n";
    for($h=0; $h<=$#ed; ++$h) {
      $ed1 = $ord[$j][$ed[$h]];
      print OUT "\t\t\t$ed1<br>\n";
    }
    print OUT "\t\t</td>\n";
  }
  print OUT "\t</tr>\n";
}

# 時期行出力
print OUT "\t<tr>\n";
print OUT "\t\t<td></td>\n";
print OUT "\t\t<td></td>\n";
foreach (@dat) {
  print OUT "\t\t<td><center>$_</center></td>\n";
}
print OUT "\t</tr>\n";

# フッタ出力
print OUT <<END_OF_FOOTER;
</table>
</body>
</html>
END_OF_FOOTER
close(OUT);

# ファイルループ終了
}
print "-"x80, "\n";

#MacPerl::Quit(2);
die "The Unhappy End";
