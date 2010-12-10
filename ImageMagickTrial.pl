#!/usr/bin/perl

use Image::Magick;

my ($image);

$image = new Image::Magick;
$image->Read("$ARGV[0]");

$image->AdaptiveResize( geometry => '700x500+100+200' );

$text = 'Copyright Statement';
$image->Annotate(
    fill       => 'white',
    gravity    => 'South',
    undercolor => '#0008',
    text => $text
);
$image->write("$ARGV[0]");
