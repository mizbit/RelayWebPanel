#!/usr/bin/perl -w
use strict ;
# use warnings ;
use CGI;
use HTML::Template;
use Encode qw(decode encode);
use JSON ;
use File::Slurp;

##############################
#### NOMBRES DE LAS LUCES ####
##############################
my @names = (
"luz-1",
"luz-2",
"luz-3",
"luz-4",
"luz-5",
"luz-6",
"luz-7",
"luz-8"
) ;
##############################
##############################
##############################

my $jsondir = "/var/www/html/susevich.json" ;
my $cgi = new CGI ;

mostrar() ;

##############################
sub mostrar
{
  my $pth = "/var/www/html/susevich.html" ;
  my $template = HTML::Template->new(filename => $pth);

  my $decoded_json = decode_json(read_file("$jsondir"));
  my $jsonlen  = scalar @{$decoded_json->{'luces'}};

  my $on ;
  my $off ;
  my $i ;
  my @loop_data = ();
  for $i (0 .. $jsonlen-1)
  {
    my %row_data;  # Genero un nuevo hash
    $row_data{nom} = "$names[$i]" ;
    $row_data{i} = $i+1 ;
    # $row_data{checked} = "checked" ;
    if ($decoded_json->{luces}[$i]{manual} eq "1")
    {
      $row_data{checked} = "checked" ;
    }
    $row_data{on} = "$decoded_json->{luces}[$i]{on}" ;
    $row_data{off} = "$decoded_json->{luces}[$i]{off}" ;
    push(@loop_data, \%row_data);
  }
  $template->param(BUTTONS => \@loop_data);

  print $cgi->header();
  print decode('UTF-8',$template->output()) ;
}
