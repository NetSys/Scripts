#!/usr/bin/perl

open FILE, "./$ARGV[0]" or die "Cannot Open $ARGV[0]";
$i =0;
while(<FILE>){
    $i++;
}
close FILE;
open FILE, "./$ARGV[0]" or die "Cannot Open $ARGV[0]";
$j =0;
while(<FILE>) {
    chomp;
    $ratio = $j++/$i;
    if($ratio < 0.0001) {
			$ratio = 0;
    }
    print $_, " ", $ratio, "\n";
}
close FILE;
