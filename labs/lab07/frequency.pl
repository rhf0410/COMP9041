#!/usr/bin/perl -w

sub specified{
    my @list=@_;
	$word=$list[0];
	open(Data, "$list[1]") or die "File can not open.";
	$n=0;
	while(<Data>){
		$str=$_;
		$str =~ s/[^a-zA-Z]/*/g;
		$str =~ tr/*+/ /;
		@arr = split(' ', $str);
		foreach $val (@arr){
			if($val =~ /^$word$/i){
				$n = $n+1;
			}
		}
	}
	return $n;
}

sub total{
    my @list = @_;
	open(Data, "$list[0]") or die "File can not open.";
	$n=0;
	while(<Data>){
		$str=$_;
		$str =~ s/[^a-zA-Z]/*/g;
		$str =~ tr/*+/ /;
		@arr = split(' ', $str);
		foreach $val (@arr){
			if($val =~ /\D/){
				$n = $n+1;
			}
		}
	}
	return $n;
}

sub getstr{
	my @list = @_;
	my $str = $list[0];
	@array = split('/', $str);
	$name = $array[1];
	$name =~ s/(\.txt)//;
	$name =~ s/_/ /g;
	return $name;
}

foreach $file (glob "lyrics/*.txt") {
        $word = $ARGV[0];
	$snum = specified($word, $file);
	$tnum = total($file);
	$res = $snum/$tnum;
        $name = getstr($file);
	printf "%4d/%6d = %.9f %s\n", $snum,$tnum,$res, $name;
}
