#!/usr/bin/perl
use strict ;
# use warnings ;
use CGI;
use Encode qw(decode encode);
use JSON ;
use File::Slurp;

my $jsondir = "/var/www/html/susevich.json" ;
my $json = new JSON ;
my %todojson ;
my @luces ;

my $decoded_json = decode_json(read_file("$jsondir"));


my $cgi = new CGI ;
my $luz ;
my $manual ;
my $on ;
my $off ;
my $i ;

my @pin = (
"xx",
"21",
"20",
"7",
"8",
"25",
"24",
"23",
"18"
) ;

my @lights ;

for $i (1 .. 8) {
  # $manual = $cgi->param("luz$i") ;
  # if($manual eq ''){$manual = 0} ;
  $manual = $decoded_json->{'luces'}[$i-1]{'manual'};
  $on = $cgi->param("on$i") ;
  $off = $cgi->param("off$i") ;

  push @luces,makejson("luz$i", $manual, $on, $off) ;

  #######
  #APAGAR Y ENCENDER LAS LUCES
  #######
  if ($manual eq 1)
  {
    push @lights , "python /var/www/html/cgi-bin/luces.py $pin[$i] $manual"  ;
  }
  else
  {
    push @lights  , "python /var/www/html/cgi-bin/luces.py $pin[$i] 0" ;
  }
  #######
}

$todojson{luces} = \@luces ;
$json->canonical(1) ;
my $output = $json->encode(\%todojson);
write_file("$jsondir", $output) ;

# foreach my $el (@lights)
# {
#   system($el) ;
# }

print $cgi->redirect("/cgi-bin/susevich.pl?ok =1") ;

# my $password = $cgi->param( "Password" );

# print $cgi->redirect("/cgi-bin/susevich.pl") ;
exit ;

###############################################################

sub makejson
{
  my %aviso ;
  my $id = shift ;
  my $manual = shift ;
  my $on = shift ;
  my $off = shift ;
  $aviso{luz} = $id ;
  $aviso{on} = $on ;
  $aviso{off} = $off ;
  $aviso{manual} = $manual ;
  \%aviso ;
}
