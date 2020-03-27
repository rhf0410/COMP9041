#!/usr/bin/perl -w

$word=$ARGV[0];
#open(Data, "$ARGV[1]") or die "File can not open.";
$n=0;
while(<STDIN>){
	$str=$_;
	$str =~ s/[^a-zA-Z]/*/g;
	$str =~ tr/*+/ /;
	@arr = split(' ', $str);
	foreach $val (@arr){
		if($val =~ /^$word$/i){
			$n = $n+1;
		}
	}
}
print "$word occurred $n times\n";

