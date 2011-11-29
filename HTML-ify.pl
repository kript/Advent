#!/usr/bin/perl
#outputs HTML version of a plain text file with HTML markup

print "<p>\n";

while (<>) 
{
	$input = $_;
	chomp($input);
	$full = $input . "<br>";
	print($full . "\n");
}
	print "</p>\n";
