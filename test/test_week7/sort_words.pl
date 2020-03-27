#!/usr/bin/perl -w

$fstr="";
while(<STDIN>){
	chomp($_);
	@arr = split(' ', $_);
	@newarr = sort @arr;
	foreach my $str (@newarr){
		$fstr .= $str;
		$fstr .= " ";
	}
	$fstr .= "\n";
}

print "$fstr";
