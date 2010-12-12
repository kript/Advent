#!/usr/bin/perl

use Image::Magick;

my ($image, $x);

$image = new Image::Magick;



  $x = $image->Read('', '', '');
  warn "$x" if "$x";

  $x = $image->Write('animation.png');
  warn "$x" if "$x";

