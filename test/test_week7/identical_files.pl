#!/usr/bin/perl -w

@arr = @ARGV;
if(@arr == 0){
	print "Usage: ./identical_files.pl <files>\n";
}
@arrs=();
foreach my $file (@arr){
	open(Data, "<$file") or die "Can not open $file\n";
	$newstr="";
	while(<Data>){
		$newstr .= $_;
		$newstr .= " ";
	}
	push(@arrs, $newstr);
	close(Data);
}
$scon = $arrs[0];
for($i=1;$i<@arrs;$i=$i+1){
	if(!($scon eq $arrs[$i])){
		print "$ARGV[$i] is not identical\n";
		exit 0;
	}
}
print "All files are identical\n";

