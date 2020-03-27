#!/usr/bin/perl -w

$n=0;
while(<STDIN>){
	$str=$_;
	$str =~ s/[^a-zA-Z]/*/g;
	$str =~ tr/*+/ /;
	@arr = split(' ', $str);
	foreach $val (@arr){
		if($val =~ /\D/){
			$n = $n+1;
		}
	}
}
print "$n words\n";
