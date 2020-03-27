#!/usr/bin/perl -w

$tnum = 0;
$res = 0;
%log_hash=();
opendir(DIR,".") or die "Can not open directory.\n";
while(my $sfile = readdir(DIR)){
	if($sfile =~ /(\.txt)$/){
		my $wfile = $sfile;
		open(SData, "<$wfile") or die "Can not open a file.\n";
		$song_name = $sfile;
		$song_name =~ s/(\.txt)//g;
		while(<SData>){
			$str = $_;
			$str =~ s/[^a-zA-Z]/*/g;
			$str =~ s/\*+/ /g;
			my @arr1 = split(' ', $str);
			foreach my $val(@arr1){
				if(exists $log_hash{$song_name}{lc $val}){
		    		$log_hash{$song_name}{lc $val}{1} += 1;
				}else{
					$log_hash{$song_name}{lc $val}{1} = 1;
				}
			}
		}
	}
}

%hash=();
foreach my $file1 (glob "lyrics/*.txt"){
	$name = $file1;
	$name =~ s/(\.txt)//g;
	$name =~ s/_/ /g;
        $name =~ s/(lyrics\/)//g;
	$tnum=0;
	if($file1 =~ /[a-zA-z ]/){
		open(Data, "<$file1") or die "Can not open $file1.\n";
		while(<Data>){
			$str = $_;
			$str =~ s/[^a-zA-Z]/*/g;
			$str =~ s/\*+/ /g;
			my @arr1 = split(' ', $str);
			foreach my $val(@arr1){
				if($val =~ /\D/){
					$tnum++;
					if(exists $hash{$name}{lc $val}){
						$hash{$name}{lc $val} += 1;
					}else{
						$hash{$name}{lc $val} = 1;
					}
				}
			}
		}
		$hash{$name}{0} = $tnum;
	}
}

@songs = keys %log_hash;
@artists = keys %hash;
%fsongs=();
foreach my $song (@songs){
	my $songs_values = $log_hash{$song};
	foreach my $artist (@artists){
		$res=0;
		foreach my $song_key (keys %$songs_values){
			my $num = $hash{$artist}{$song_key};
			$num += 1;
			my $tnum = $hash{$artist}{0};
			$res += $log_hash{$song}{$song_key}{1} * log($num/$tnum);
		}
		$fsongs{$song}{$artist}=$res;
	}
}

%result=();
foreach my $my_song (sort{$a cmp $b} keys %fsongs){
	my $mhash = $fsongs{$my_song};
	$i=0;
	foreach my $key (sort{$fsongs{$my_song}{$b}<=>$fsongs{$my_song}{$a}} keys %$mhash){
		if($i == 0){
			$result{$my_song}=$fsongs{$my_song}{$key};
			$result{$my_song}{1}=$key;
			$i += 1;
		}
	}
}
if($ARGV[0] eq "-d"){
	$music=$ARGV[1];
	$music =~ s/(\.txt)//g;
	my $mhash = $fsongs{$music};
	foreach my $key (sort{$fsongs{$music}{$b}<=>$fsongs{$music}{$a}} keys %$mhash){
		printf "%s\.txt: log_probability of %.1f for %s\n", $music, $fsongs{$music}{$key}, $key;
	}
	printf "%s\.txt most resembles the work of %s (log-probability=%.1f)\n", $music, $result{$music}{1}, $result{$music};
}else{
	@arrs = @ARGV;
	foreach $file (@arrs){
		$music=$file;
		$music =~ s/(\.txt)//g;
		printf "%s\.txt most resembles the work of %s (log-probability=%.1f)\n", $music, $result{$music}{1}, $result{$music};
	}
}
