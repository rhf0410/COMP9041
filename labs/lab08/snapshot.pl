#!/usr/bin/perl -w
use File::Copy;
use Cwd;

$dir=".snapshot";
$count=0;
$newdir = $dir.".".$count;
while(-d $newdir){
	@refs=split('\.', $newdir);
	$count = $refs[2];
	$count += 1;
	$newdir = $dir.".".$count;
}
mkdir $newdir;

if($ARGV[0] eq "save"){
	@files=();
	foreach my $file1 (glob "*"){
		if(!($file1 eq "snapshot") and !($file1 =~ /^"\."/)){
			push @files, $file1;
		}
	}
	foreach my $file (@files){
		copy($file, $newdir);
	}
	print "Creating snapshot $count\n";
}

if($ARGV[0] eq "load"){
	@files=();
	foreach my $file1 (glob "*"){
		if(!($file1 eq "snapshot") and !($file1 =~ /^"\."/)){
			push @files, $file1;
		}
	}
	foreach my $file (@files){
		copy($file, $newdir);
	}
	print "Creating snapshot $count\n";
	$resfile=$dir.".".$ARGV[1];
	$path=getcwd;
	foreach my $file2 (glob "$resfile/*"){
		copy($file2, $path);
	}
	print "Restoring snapshot $ARGV[1]\n";
}
