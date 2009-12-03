#!/usr/bin/perl -w

use strict;
use warnings;
use CGI ':standard';
use Tie::Handle::CSV;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;


my $AdventIndexFile = "index.html";
my $DestinationDir = "./advent";
my $SiteConfigFile = "site.csv";
my $DaysConfigFile = "days.csv";
my $dir = "advent";

#process the command line options
getopts( 'i:hf:l:m:u:', \my %opt );    # parse user input
pod2usage(1) if ( defined $opt{h} );


sub ReadInSiteConfig
{
	my %Site;
 	my $csv_fh = Tie::Handle::CSV->new($SiteConfigFile, header => 1) 
		or die "Cannot open $SiteConfigFile: $!\n";

   	while (my $csv_line = <$csv_fh>)
      	{
      		$Site{'title'} = $csv_line->{'title'} ;
      		$Site{'titlefontcolour'} = $csv_line->{'titlefontcolour'} ;
      		$Site{'imagefile'} = $csv_line->{'imagefile'} ;
      	}
   	close $csv_fh;
	
	print Dumper(%Site);

	return (\%Site);
}

sub ReadInAdventConfigs
{

	my @Advent;
 	my $csv_fh = Tie::Handle::CSV->new($DaysConfigFile, header => 1) 
		or die "Cannot open $DaysConfigFile: $!\n";

	my $DayCount = 0;

   	while (my $csv_line = <$csv_fh>)
      	{
      		$Advent[$DayCount]{'day'} = $csv_line->{'day'} ;
      		$Advent[$DayCount]{'left'} = $csv_line->{'left'} ;
      		$Advent[$DayCount]{'top'} = $csv_line->{'top'} ;
      		$Advent[$DayCount]{'alt'} = $csv_line->{'alt'} ;
      		$Advent[$DayCount]{'dayimagefile'} = $csv_line->{'dayimagefile'} ;
      		$Advent[$DayCount]{'daytextfile'} = $csv_line->{'daytextfile'} ;
		$DayCount++;
      	}
   	close $csv_fh;
	print Dumper(@Advent);
	return (@Advent);
}

sub BuildAdventIndex
{

	my $AdventIndexFile = shift;
	my $Site = shift;

	open (ADVENTINDEX,">$AdventIndexFile") or 
		die "unable to write to file $AdventIndexFile: $!";

	print ADVENTINDEX header;
        print ADVENTINDEX start_html($$Site{'title'});
        print ADVENTINDEX h1($$Site{'title'});
	print img {src=>$$Site{'imagefile'},align=>'CENTER'};
	print ADVENTINDEX end_html; 

	close ADVENTINDEX 
		or die "cannot close $AdventIndexFile: $!";
}

sub BuildIndividualAdvents
{

}

#####main program control starts here

my @Advents = ReadInAdventConfigs();
my $Site = ReadInSiteConfig(); #this actually returns a reference to a hash

mkdir($dir) or die "cannot create $dir: $!";
chdir($dir);

BuildAdventIndex($AdventIndexFile,$Site);





=head1 GenerateAdventCalender.pl

Generate an advent calender page which has links to sub pages which contain images and text.

=head1 VERSION

0.1

=head1 SYNOPSIS

$0 

Script to Generate an advent calender page which has links to sub pages which contain images and text.

-h displays this page

Takes two files; site.csv and days.csv with the following format;

site.csv

title,titlefontcolour,imagefile

e.g.
Advent calender,#ffffff,/advent2009/advent.png

days.csv

day,left,top,alt,dayimagefile,daytextfile

e.g.

1,580,430,drummers busking,/advent2009/1.png,/advent2009/1.txt

note that the file locations are relative to the site - the script will create a advent subdir in the directory its run under, and create all the files there.  This then can be copied to a web directory of the same name eg.

script is run in /home/john/code/advent
creates /home/john/code/advent/advent
the content of which is then copies to advent2009/ on the webserver.

this could be better, but.. 
=head1 BUGS AND LIMITATIONS

There are no known bugs in this script.

Please report problems to John Constable (John@kript.net)

Patches are welcome. a git repository is forthcoming..

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009  John Constable (John@kript.net)
All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.  This program is
distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.


