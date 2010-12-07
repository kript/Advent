#!/usr/bin/perl -w

use strict;
use warnings;
use CGI ( ':standard', 'div' );
use Tie::Handle::CSV;
use Getopt::Std;
use Pod::Usage;
use Data::Dumper;
use Acme::ProgressBar;

my $AdventIndexFile = "index.html";
my $DestinationDir  = "./advent";
my $SiteConfigFile  = "site.csv";
my $DaysConfigFile  = "days.csv";
my $dir             = "advent";

my $Style = <<STYLE;
<!-- 
body 
{
	background: #000000; 
	color: white; 
	font: bold 12px arial;}
a{ color: white; }
a:visited{ color: #400}
div a{
  position: absolute;
  padding: 30px 5px 2px 45px;
  border: 2px solid #448;
  text-align:right;
}
-->
STYLE

#process the command line options
getopts( 'i:hf:l:m:u:', \my %opt );    # parse user input
pod2usage(1) if ( defined $opt{h} );

sub ReadInSiteConfig {
    my %Site;
    my $csv_fh = Tie::Handle::CSV->new( $SiteConfigFile, header => 1 )
      or die "Cannot open $SiteConfigFile: $!\n";

    while ( my $csv_line = <$csv_fh> ) {
        $Site{'title'}           = $csv_line->{'title'};
        $Site{'titlefontcolour'} = $csv_line->{'titlefontcolour'};
        $Site{'background'}      = $csv_line->{'background'};
        $Site{'imagefile'}       = $csv_line->{'imagefile'};
        $Site{'height'}          = $csv_line->{'height'};
        $Site{'width'}           = $csv_line->{'width'};
        $Site{'copyright'}       = $csv_line->{'copyright'};
    }
    close $csv_fh;

    #	print Dumper(%Site);
    return ( \%Site );
}

sub ReadInAdventConfigs {
    my @Advent;
    my $csv_fh = Tie::Handle::CSV->new( $DaysConfigFile, header => 1 )
      or die "Cannot open $DaysConfigFile: $!\n";

    my $DayCount = 0;

    while ( my $csv_line = <$csv_fh> ) {

        unless ( ( $csv_line->{'day'} ) ) {
            print("incomplete day definition in days.csv\n");
            next;
        }

        $Advent[$DayCount]{'day'}          = $csv_line->{'day'};
        $Advent[$DayCount]{'left'}         = $csv_line->{'left'};
        $Advent[$DayCount]{'top'}          = $csv_line->{'top'};
        $Advent[$DayCount]{'alt'}          = $csv_line->{'alt'};
        $Advent[$DayCount]{'dayimagefile'} = $csv_line->{'dayimagefile'};
        $Advent[$DayCount]{'daytextfile'}  = $csv_line->{'daytextfile'};
        $Advent[$DayCount]{'copyright'}    = $csv_line->{'copyright'};
        $DayCount++;
    }
    close $csv_fh;

    #	print Dumper(@Advent);
    return (@Advent);
}

sub BuildAdventIndex {

    my $AdventIndexFile = shift;
    my $Style           = shift;
    my $Site            = shift;

    # 	print Dumper($Site);
    my @Advent = @_;

    open( ADVENTINDEX, "+>$AdventIndexFile" )
      or die "unable to write to file $AdventIndexFile: $!";

    print ADVENTINDEX start_html(
        -title   => "$$Site->{'title'}",
        -BGCOLOR => "$$Site->{'background'}",
        -style   => { code => $Style }
    );
    print ADVENTINDEX h1(
        {
            -style => "Color: $$Site->{'titlefontcolour'};
		position: absolute; center: 25px; left: 250px; z-index:5"
        },
        "$$Site->{'title'}"
    );
    print ADVENTINDEX img {
        src    => "$$Site->{'imagefile'}",
        align  => 'CENTER',
        height => "$$Site->{'height'}",
        width  => "$$Site->{'width'}",
        style  => "position: absolute; top: 15px; left: 15px"
    };
    print ADVENTINDEX h2( { -style => "Color: $$Site->{'titlefontcolour'};" },
        "Copyright: $$Site->{'copyright'}" );

    print ADVENTINDEX "\n";

    my $count;
    for my $day (@Advent) {

        unless ( ( $$day{'day'} ) ) {
            print("incomplete day definition in days.csv\n");
            next;
        }

        #		print Dumper($day);
        $count++;
        print ADVENTINDEX br();
        print ADVENTINDEX CGI::div(
            a(
                {
                    -href => "$count.html",
                    -style =>
                      "left: $$day{'left'}px; top: $$day{'top'}px; z-index:9"
                },
                "$count"
            )
        );
        print ADVENTINDEX "\n";
    }

    print ADVENTINDEX end_html;

    close ADVENTINDEX
      or die "cannot close $AdventIndexFile: $!";
}

sub BuildIndividualAdvents {
    my @Advent = @_;

    # 	print Dumper(@Advent);

    progress {
        for my $days (@Advent) {

            #	print Dumper($days);
            unless ( ( $days->{'day'} ) ) {
                print("incomplete day definition in days.csv\n");
                next;
            }
            my $AdventFile = $days->{'day'} . ".html";

            open( ADVENT, "+>$AdventFile" )
              or die "unable to write to file $AdventFile: $!";

            print ADVENT start_html( -title => "$days->{'alt'}" );
            print ADVENT h1( $days->{'alt'} );
            print ADVENT img { src => "$days->{'dayimagefile'}",
                align => 'CENTER' };

            print ADVENT "\n";
            print ADVENT h2("Copyright: $days->{'copyright'}");
            print ADVENT "\n";

            open( ADVENTTXT, "<$days->{'daytextfile'}" )
              or die "unable to read from file $days->{'daytextfile'}: $!";

            while (<ADVENTTXT>) {
                print ADVENT $_;
            }

            close ADVENTTXT
              or die "unable to write to file $days->{'daytextfile'}: $!";

            print ADVENT "\n";
            close ADVENT
              or die "unable to write to file $AdventFile: $!";

        }
    }
}

#####main program control starts here

my @Advents = ReadInAdventConfigs();
my $Site    = ReadInSiteConfig();   #this actually returns a reference to a hash

#print Dumper(@Advents);

unless ( -d $dir ) { mkdir($dir) or die "cannot create $dir: $!"; }
chdir($dir);

BuildAdventIndex( $AdventIndexFile, $Style, \$Site, @Advents );
BuildIndividualAdvents(@Advents);

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

title,titlefontcolour,background,imagefile,height,width

e.g.
Advent calender,#ffffff,black,/advent2009/advent.png,765,368

days.csv

day,left,top,alt,dayimagefile,daytextfile

e.g.

1,580,430,drummers busking,/advent2009/1.png,/advent2009/1.txt

By omitting the 'day' entry, you can cause the script to ignore the line - its a way to allow you to build the file in situ, should you accrete the content over time

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


