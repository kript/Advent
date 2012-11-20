#!/bin/bash
# script to preprocess images for upload to advent calender

file=$1
copyr=$2
width=`/usr/local/bin/identify -format %w $file`

/usr/local/bin/convert $1 -resize 419200@ $1

/usr/local/bin/convert -background '#0008' -fill white -gravity center -size ${width}x30 caption:"$copyr" $file +swap -gravity south -composite $file 
