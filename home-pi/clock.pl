#!/usr/bin/perl
use strict ;
# use warnings ;
use CGI;
use Encode qw(decode encode);
use JSON ;
use File::Slurp;

my @pin = ("21","20","7","8","25","24","23","18") ;

my ($sec,$min,$hour) = localtime();
my @lights ;

my $jsonpth = "/var/www/html/susevich.json" ;
my $json = new JSON ;

my $decoded_json = decode_json(read_file($jsonpth));

my ($h_on,$m_on,$h_off,$m_off, $manual);
my $i = 0;
foreach my $x (@{$decoded_json->{'luces'}})
{
  ($h_on,$m_on) = split(/\:/, $x->{on});
  ($h_off,$m_off) = split(/\:/, $x->{off});
  $manual = $x->{manual} ;

  if ($h_off ne '' && $m_off ne '' && $h_on ne '' && $m_on ne '')
  {
      if (($hour > $h_on && $hour < $h_off)
      || ($hour == $h_on && $min > $m_on))
      {
        $x->{manual} = 1 ;
        push @lights , "python /var/www/html/cgi-bin/luces.py $pin[$i] 1"  ;
        print ("ENCENDER pin $pin[$i] $x->{luz} porque su hora es $h_on:$m_on y la hora actual es $hour:$min\n" ) ;
      }
      else
      {
        $x->{manual} = 0 ;
        push @lights  , "python /var/www/html/cgi-bin/luces.py $pin[$i] 0" ;
        print ("APAGAR pin $pin[$i] $x->{luz} porque su hora es $h_on:$m_on y la hora actual es $hour:$min\n" ) ;
      }
  }
  else
  {
    push @lights  , "python /var/www/html/cgi-bin/luces.py $pin[$i] 0" ;
  }
  $i++ ;
}

foreach my $el (@lights)
{
  # print ("$el \n") ;
  system($el) ;
}

$json->canonical(1) ;
my $output = $json->encode($decoded_json);
write_file("$jsonpth", $output) ;

exit ;
