#!/usr/bin/perl -w

open(Data, "<$ARGV[0]") or die "Can not open $ARGV[0]\n";
#%hash=();
while(<Data>){
	my $len=length($_);
	$hash{$len}.= $_."\*";
}

@keys = keys %hash;
foreach my $val (sort{$a <=> $b} @keys){
	$str=$hash{$val};
	@strs=split('\*', $str);
	foreach my $strc (sort{$a cmp $b} @strs){
		print "$strc";
	}
}
