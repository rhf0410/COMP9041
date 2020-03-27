#!/usr/bin/perl

%hash=();
open(Data, "<$ARGV[0]") or die "$ARGV[0] cannot open.";
while(<Data>){
    @nums = split(' ', $_);
    $name = lc($nums[2]);
    for($i=3;$i<@nums;$i=$i+1){
    	$name .= " ";
    	$name .= lc($nums[$i])
    }
    $pod = $nums[1];
	if(exists($hash{$name})){
	    $str=$hash{$name};
	    @nnums=split(',',$str);
	    $num=$nnums[0]+$pod;
	    $count=$nnums[1] + 1;
	    $hash{$name}=$num.",$count";
	}else{
	    $pod=$pod.",1";
		$hash{$name}=$pod;
	}
}

@keys = keys %hash;
foreach my $key(@keys){
	$newkey = $key."s";
	if(exists($hash{$newkey})){
	    @res1 = split(',', $hash{$newkey});
	    @res2 = split(',', $hash{$key});
	    $num=$res1[0]+$res2[0];
	    $pod=$res1[1]+$res2[1];
	    $hash{$key}=$num.",$pod";
	    delete $hash{$newkey};
	}
}

foreach my $key(sort{$a cmp $b} keys %hash){
	@res=split(',', $hash{$key});
	print "$key observations: $res[1] pods, $res[0] individuals\n";
}
