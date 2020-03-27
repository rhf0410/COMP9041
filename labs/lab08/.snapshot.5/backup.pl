#!/usr/bin/perl -w

open(Data, "<$ARGV[0]") or die "File can not open.";
$file=$ARGV[0];
$newfile=".n.txt";
$nfile="";
if($file =~ /[0-9]$/){
	@files=split('.', $file);
	$newnum=$files[4];
	$newnum += 1;
	$nfile=$newfile.".$newnum";
}else{
	$nfile=$newfile.".0";
}
while(-e $nfile){
	@files=split('.', $nfile);
	$newnum++;
	$nfile=$newfile.".$newnum";
}
$newfile=$nfile;
open(OUT,">>$newfile") or die "Can not open a file.";
while(<Data>){
	print OUT $_;
}
print "Backup of '$ARGV[0]' saved as '$newfile'\n";
