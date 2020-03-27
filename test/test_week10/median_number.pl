#!/usr/bin/perl -w

@arr = ();
foreach $i (sort{$a <=> $b} @ARGV){
	push @arr,$i;
}

$num = @arr;
$median = 0;
if($num%2 == 0){
	$num = $num/2;
	$median = ($arr[$num] + $arr[$num-1])/2;
}else{
	$num = $num/2;
	$median = $arr[$num];
}
print "$median\n";
