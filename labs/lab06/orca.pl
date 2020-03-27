#!/usr/bin/perl

open(Data, "<$ARGV[0]") or die "$ARGV[0] can not open.";
$count=0;
while(<Data>){
	if($_ =~ /.*Orca.*/){
		@nums=split(' ', $_);
		$num=$nums[1];
		$count=$count+$num;
	}
}
print "$count Orcas reported in $ARGV[0]\n";
