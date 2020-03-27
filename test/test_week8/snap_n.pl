#!/usr/bin/perl -w

%hash=();
while(<STDIN>){
	if(exists $hash{$_}){
		$hash{$_}++;
	}else{
		$hash{$_}=1;
	}
	if($hash{$_} == $ARGV[0]){
		print "Snap: $_";
		last;
	}
}
