#!/usr/bin/perl -w

if(-z $ARGV[0]){
    exit 0;
}
open (DATA, "<$ARGV[0]") or die "Can not open file $ARGV[0]";
@res=();
while(<DATA>){
	push @res,$_;
}
$num = @res;
if($num % 2 == 1){
	print "$res[$num/2]";
}else{
	print "$res[$num/2 - 1]";
	print "$res[$num/2]";
}
