#!/usr/bin/perl
use strict;
use warnings;
use 5.01;

{
  package Business::PertChart::Entry;
  use Any::Moose;
  use Any::Moose '::Types::';
  has chart => (
                is       => 'ro',
                required => 1,
                is_weak  => 1
               );
  has name => (
               is  => 'ro',
               isa => Str
              );
}


{
  package Business::PertChart;
  use Any::Moose;
  has dates => (
                is      => 'ro',
                isa       => 'ArrayRef',
                autoderef => 1,
                default => sub{
                  []
                }
               );

  has _pathes => (
                  is        => 'ro',
                  autoderef => 1,
                  default => sub{
                    []
                  }
                 );

  has entries_dic => (
                      is      => 'ro',
                      isa       => 'HashRef',
                      autoderef => 1,
                      default => sub{
                        {}
                      }
                     );

  has entries => (
                  is => 'ro',
                  isa => 'ArrayRef',
                  autoderef => 1,
                  default => sub{
                    []
                  }
                 );

  sub add_entry {
    my ($this, $entry) = @_;
    return if exists ${$this->entries_dic}{$entry};
    my $entries = $this->entries;
    push @$entries, $entry;
    $this->entries_dic->{$entry} = scalar @$entries;
  }

  sub calculate_path {
    
  }

}



###
### see also
###
### http://homepage3.nifty.com/Nowral/46_Kango/46_Kango.html
###

use File::Basename;
use Text::ParseWords;
use Getopt::Std;
use Path::Class;

sub input{
  my %opt = @_;
  my $csv = $opt{csv};

  open(IN, $csv);

  # クリニカルパス読込み
  my @dat;  # 時期名称
  my $cls1; # 小分類
  my $cls;  # 大分類
  my %ent;  # 分類名称

  my @pth;  # パス
  my @ord;  # 項目リスト

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

  my $j = -1;
  while(<IN>) {
    chomp;

    # 文字種統一
    my @ed = map {
      tr/,/、/;
      tr/　//d;
      tr/（）/\(\)/;
      tr/０-９ａ-ｚＡ-Ｚ/0-9a-zA-Z/; # 半角英数
    } (quotewords(",", 0, $_));
    next unless @ed;

    # 時期行<必須
    unless(@dat) {
      @dat = @ed[2 .. $#ed];
      next;
    }

    my $ed1 = shift @ed;

    # 項目行 # 大分類
    if($ed1)
      {
        $cls  = $ed1;
        $cls1 = $ed1;
      }

    $ed1 = shift @ed;
    $cls = "$cls1\t$ed1" if($ed1);  # 小分類

    # 初見の分類?
    unless(exists $ent{$cls}) {
      ++$j;
      $ent{$cls} = $j;
      undef @{$pth[$j]};
    }

    # ケア項目追加
    for(my $i=0; $i< @dat; $i++) {
      $ed1 = shift @ed;
      next unless $ed1;
      my $orig = $pth[$j][$i] || "";
      $pth[$j][$i] = ($orig ? "\t" : "") . $ed1;
      last unless @ed;
    }
  }
  close(IN);

  my @tne = ();
  $tne[$ent{$_}] = $_ foreach keys %ent;

  # 番号置換
  my $len = @{[keys %ent]};
  for(my $j=0; $j< $len; ++$j) {
    $ord[$j][0] = ""; # NOP
    for(my $i=0; $i<=@dat; ++$i) {
      next unless $pth[$j][$i];

      my @ed = ();
      foreach my $ed1 (split("\t", $pth[$j][$i])) {
        my $h = 1;
        for(; $h < @{$ord[$j]}; ++$h) {
          last if($ord[$j][$h] eq $ed1);
        }
        push(@{$ord[$j]}, $ed1) if($h>$#{$ord[$j]});
        push(@ed, $h);
      }
      $pth[$j][$i] = join("\t", sort{$a<=>$b} @ed);
    }
  }

  +{
    dat  => \@dat,
    ent  => \%ent,
    tne  => \@tne,
    path => \@pth,
    ord  => \@ord
   }
}



sub output_html{
  my (%opt) = @_;
  my @dat = @{$opt{dat}};
  my @tne = @{$opt{tne}};
  my @pth = @{$opt{pth}};
  my @ord = @{$opt{ord}};

  # 内容出力
  my @rows = ();
  my $cls1 = "";
  my $loe = 0;

  for(my $j=0; $j <= @tne; ++$j) {

    my $entry = $tne[$j];

    # 分類名称
    my ($ed1, $cls) = split("\t", $entry);
    if($cls)
      {
        if($cls1 ne $ed1)
          {
            # 大見出し
            $cls1  = $ed1;
            my $j2 = $j+1;
            # rowspan の計算
            for(; $j2 <= @tne; ++$j2)
              {
                last unless (split("\t", $tne[$j2]))[0] eq $cls1;
              }
            my $rowspan = $j2 - $j;
            ++$loe;
            push @rows, sprintf('    <tr class="%s">'.
                                '      <th rowspan="%d">%s</th>',
                                ($loe % 2 ? 'odd' : 'even'),
                                $rowspan,
                                $cls1);
          }
        else
          {
            # 小見出し
            push @rows, sprintf('    <tr class="%s">',
                                ($loe % 2 ? 'odd' : 'even'));
          }
        push @rows, "<th>$cls</th>";
      }
    else
      {
        ++$loe;
        push @rows,  sprintf('    <tr class="%s"><th colspan="2">%s</th>',
                             ($loe % 2 ? 'odd' : 'even'),
                             $ed1);
      }

    # 項目書出し
    for(my $i=0; $i<=@dat; ++$i)
      {
        unless($pth[$j][$i])
          {
            push @rows, 
              sprintf("    <td onMouseOver=\"msg(\'%s, %s\')\"></td>",
                      $tne[$j], $dat[$i]);;
            next;
          }

        my @ed = split("\t", $pth[$j][$i]);
        push @rows, sprintf("    <td onMouseOver=\"msg(\'%s,%s\')\">",
                            $tne[$j], $dat[$i]);

        for(my $h=0; $h<=$#ed; ++$h)
          {
            $ed1 = $ord[$j][$ed[$h]];
            push @rows, " $ed1<br>";
          }
        push @rows, " </td>";
      }

    push @rows, "</tr>\n";
  }

  my $tmpl = join "", <DATA>;
  my %fields = (
                title => $opt{title},
                dat   => map("<td>$_</td>", @dat),
                rows  => join("", @rows),
               );
  my $dst = $tmpl;
  $dst =~ s<
             {:(.*?):}
         ><
           $fields{$1}
         >gex;
  $dst;
}

sub output_dot{
  my %opt = @_;
  my @dat = @{$opt{dat}};
  my @pth = @{$opt{pth}};
  my @tne = @{$opt{tne}};
  my @ord = @{$opt{ord}};
  my @data = ();
  my $dat =  join "", map( " \"%s\"", @dat);

  for(my $j=0; $j<=$#tne; ++$j)
    {
      for(my $i=0; $i<=$#dat; ++$i)
        {
          next unless $pth[$j][$i];
          my @ed = split("\t", $pth[$j][$i]);
          for(my $h=0; $h<$#ed; ++$h)
            {
              #  LR_0 -> LR_2 [ label = "SS(B)" ];
              my @dd = split(/\./, $ed[$h]);
              push @data,
                sprintf(
                        "\t\"%s\" -> \"%s\" [ label = \"%s\" ];\n",
                        $dat[$i],
                        $dat[$i+$dd[1]],
                        $ord[$j][$dd[0]]
                       );
            }
        }
    }
  my $data = join "", @data;

  return <<__EOD__;
digraph finite_state_machine {
  rankdir = LR;
  size    = "8,5"
  orientation = land;
  node [shape = circle];
  $dat
  $data
}
__EOD__
}


############################################################
MAIN:
{
  my %Opts;
  getopts('t:', \%Opts);
  my $csv = shift;
  exit unless $csv && -f $csv;

  my $ttl  = $Opts{t} || 'pert';
  my $data = input(csv => $csv);


  my $html = $csv;
  $html =~ s/\.csv$/\.html/;
  my $fh_html = file($html)->openw;
  $fh_html->print(output_html(
                         title => $ttl,
                         %$data
                        ));
  $fh_html->close();

  my $dot = $csv;
  $dot =~ s/\.csv$/\.dot/;
  my $fh_dot = file($dot)->openw;
  $fh_dot->print(output_dot( title => $ttl,
                         %$data ));
  $fh_dot->close;

}

__END__

<html>
<head>
  <title>{:title:}</title>
  <meta http-equiv="content-type" content="text/html; charset=utf-8">
<script type="text/javascript">
//<!--
function msg(str) {
  status = str;
}
//-->
</script>
</head>
<body>
<h2><i>{:title:}</i></h2>

<table border="0" cellspacing="1" cellpadding="3">
    <thead>
    <tr><td></td>
        <td></td>
        {:dat:}
    </tr>
    </thead>
    <tbody>

{:rows:}

    </tbody>
    <tfoot>
    <tr><td></td>
        <td></td>
        {:dat:}
    </tr>
    </tfoot>
</table>
</body>
</html>
