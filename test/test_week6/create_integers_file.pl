#!/usr/bin/perl -w

open(Data, ">>$ARGV[2]") or die "File cannot open.";
for($i=$ARGV[0];$i<=$ARGV[1];$i=$i+1){
	print Data "$i\n";
}
close(Data);
