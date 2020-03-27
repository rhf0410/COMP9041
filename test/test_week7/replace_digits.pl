#!/usr/bin/perl -w

open(Data,"<$ARGV[0]") or die "Can not open a file.";
$newstr="";
while(<Data>){
	$str = $_;
	$str =~ s/[0-9]/#/g;
	$newstr .= $str;
}
close(Data);
open(OUT, ">$ARGV[0]") or die "Can not open a file.";
print OUT $newstr;
close(OUT);

