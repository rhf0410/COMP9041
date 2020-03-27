#!/usr/bin/perl -w

open(Data, "<$ARGV[1]") or die "File cannot open";
@arrays = <Data>;
if($ARGV[0] > @arrays){
	exit;
}
print "$arrays[$ARGV[0]-1]";
