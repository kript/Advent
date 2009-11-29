#!/usr/bin/perl -w

use strict;
use warnings;
use CGI;
use Tie::Handle::CSV;
use Getopt::Std;
use Pod::Usage;


my $AdventIndexFile = "index.html";
my $DestinationDir = "./advent";

getopts( 'i:hf:l:m:u:', \my %opt );    # parse user input
pod2usage(1) if ( defined $opt{h} );

sub Usage
{

}

sub BuildAdventIndex
{
	
}

sub BuildIndividualAdvents
{

}

sub ReadInSiteConfig
{

}

sub ReadInAdventConfigs
{

}




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
========
title,titlefontcolour,imagefile

e.g.
Advent calender,#ffffff,/advent2009/advent.png

days.csv
========
day,left,top,alt,dayimagefile

e.g.

1,580,430,drummers busking,/advent2009/1.png

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


