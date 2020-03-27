#!/usr/bin/perl

open(Data, "<$ARGV[1]") or die "$ARGV[1] cannot open.";

$count=0;
$num = 0;
while(<Data>){
	if($_ =~ /.*$ARGV[0].*/){
		@nums = split(' ', $_);
		$num = $num + $nums[1];
		$count = $count + 1;
	}
}
print "$ARGV[0] observations: $count pods, $num individuals\n";
