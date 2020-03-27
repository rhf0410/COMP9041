#!/usr/bin/perl

$def = 10; 
@datum = <STDIN>;
for($k=@datum - $def;$k<@datum;$k++){
	print "$datum[$k]";
}
$rsize = @ARGV;

if($ARGV[0] =~ '^[-][0-9]+$'){
	@nums = split('-', $ARGV[0]);
	$def = $nums[1]; 
	$rsize--;
}

for($i=0;$i<@ARGV;$i++){
	if($ARGV[$i] =~ '[\.txt]$'){
	    $file = $ARGV[$i];
	    if($rsize > 1){
	    	print "==> $file <==\n"
		}
	    $newfile = "<";
		$newfile .= $file;
		open(Data, $newfile) or die "./tail.pl: can't open $file";
		@array = <Data>;
		$size = @array;
		$amount = $size - $def;
		if($size < $def){
			print "A one line file.\n";
			next;
		}
		for($j=$amount;$j<@array;$j++){
			print "$array[$j]";
		}
		close(Data) || die "Cannot close a file.\n";
	}
}

