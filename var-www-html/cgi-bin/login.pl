#!/usr/bin/perl
use strict ;
# use warnings ;
use CGI;
use Encode qw(decode encode);
use JSON ;
use File::Slurp;
my $cgi = new CGI ;

my $usr = $cgi->param("usr") ;
my $pwd = $cgi->param("pwd") ;

if($usr eq 'xxx' && $pwd eq 'xxx')
{
  print $cgi->redirect("/cgi-bin/susevich.pl") ;
  my $ses = rand(5) ;
  write_file("/tmp/ses", $ses);
}
else
{
  system("rm /tmp/ses");
  print "BAD USER OR PDW" ;
  exit;
}
