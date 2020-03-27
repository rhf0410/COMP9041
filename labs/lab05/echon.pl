#!/usr/bin/perl

my $amount=$ARGV[0];
my $content=$ARGV[1];
my $count = @ARGV;

if($count < 2){
	print "Usage: ./echon.pl <number of lines> <string>\n";
	exit;
}

if($count > 2){
	print "Usage: ./echon.pl <number of lines> <string>\n";
	exit;
}

if($amount =~ '^[-]' or $amount =~ '[^0-9]'){
	print "./echon.pl: argument 1 must be a non-negative integer\n";
	exit;
}

for($i=0;$i<$amount;$i++){
	print "$content\n";
}
