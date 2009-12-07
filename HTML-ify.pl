#!/usr/bin/perl

print "<p>\n";

while (<>) 
{
	$input = $_;
	chomp($input);
	$full = $input . "<br>";
	print($full . "\n");
}
	print "</p>\n";
