#!/usr/bin/perl -w

@arrs=@ARGV;
@res=();
foreach my $val (@arrs){
	if(!(grep { $_ eq $val } @res)){
		push @res, $val;
	}
}
foreach my $val (@res){
	print "$val ";
}
print "\n";
