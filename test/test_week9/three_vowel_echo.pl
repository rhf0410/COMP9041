#!/usr/bin/perl -w

@res=();
foreach my $word (@ARGV){
	if($word =~ /[aeiouAEIOU]{3,}/){
		push @res, $word;
	}
}

foreach my $r (@res){
	print "$r ";
}
print "\n";
