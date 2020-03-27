#!/usr/bin/perl -w

$dir1="$ARGV[0]/";
$dir2="$ARGV[1]/";
@arr=();
opendir(DIR, $dir1) or die "Can not open directory $dir1.\n";
@arr=readdir DIR;

@res=();
foreach $file (@arr){
    if(-f "$dir2$file"){
    	if(compFile("$dir1$file", "$dir2$file")){
			push @res, $file;
		}
    }
}

foreach $file (sort{$a cmp $b} @res){
	print "$file\n";
}

sub compFile{
	my @param=@_;
	my $file1=$param[0];
	my $file2=$param[1];
	open(A, "<$file1") or die "Can not open the file $file1.\n";
	open(B, "<$file2") or die "Can not open the file $file2.\n";
	my @a=<A>;
	my @b=<B>;
	my $numa=@a;
	my $numb=@b;
	if($numa != $numb){
		return 0;
	}
	for($i=0;$i<$numa;$i=$i+1){
		if($a[$i] ne $b[$i]){
			return 0;
		}
	}
	close B;
	close A;
	return 1;
}
