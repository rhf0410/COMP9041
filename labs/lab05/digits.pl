#!/usr/bin/perl

chomp(@stdin=<STDIN>);
foreach $a (@stdin){
	$a =~ tr/[0-4]/</;
	$a =~ tr/[6-9]/>/;
	print STDOUT"$a\n";
}
