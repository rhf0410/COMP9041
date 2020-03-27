#!/usr/bin/perl -w

@res=<STDIN>;
$max=0;
$flag = 1;
foreach my $r (@res){
	$val=$r;
	$val =~ s/[^\d\.-]/ /g;
	$val =~ s/[-]+/-/g;
	$val =~ s/[ ]+/ /g;
	@nums = split(' ', $val);
	foreach my $num (@nums){
	    $num =~ s/[\.]$//g;
	    $num =~ s/[\.]/0\./g;
	    $num =~ s/[-]$//g;
		if($num eq ""){
			$num=0;
		}
		if($flag == 1){
			$max = $num;
			$flag = 2;
		}
		if($num > $max){
			$max=$num;
		}
	}
}
@puts = ();
$max =~ s/0\./\./g;
$max =~ s/(\.0)$//g;
foreach my $sen (@res){
	if($sen =~ /$max/){
		push @puts, $sen;
	}
}
foreach my $rv (@puts){
	print "$rv";
}
