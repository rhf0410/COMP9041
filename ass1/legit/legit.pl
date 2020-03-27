#!/usr/bin/perl -w
use File::Copy;
use Cwd;

#Create structure graph by the relation file.
%hash = ();
if(-e "\.legit/relations"){
	open(RELATION, "<\.legit/relations") or die "Fail to open the relation file\n";
	while(<RELATION>){
		@params=split(" ", $_);
		$front = $params[0];
		$post = $params[1];
		if(exists $hash{$front}){
			$hash{$front}{"post"} .= "$post ";
		}else{
			$hash{$front}{"front"} = "";
			$hash{$front}{"post"} = "$post ";
		}
		if(exists $hash{$post}){
			$hash{$post}{"front"} .= "$front ";
		}else{
			$hash{$post}{"front"} = "$front ";
			$hash{$post}{"post"} = "";
		}
	}
	close RELATION;
	#@keys = keys %hash;
	#foreach my $key (@keys){
		#print "$key\n";
		#$name1 = $hash{$key}{"front"};
		#$name2 = $hash{$key}{"post"};
		#print "front: $name1\n";
		#print "post: $name2\n";
	#}
}

#legit.pl init.
if($ARGV[0] eq "init"){
	init();
}

#legit.pl add filenames
if($ARGV[0] eq "add"){
	add(@ARGV);
}

#legit.pl commit -m message
if($ARGV[0] eq "commit"){
    $length=@ARGV;
    $message="";
    if($length lt 3){
        print "error:switch 'm' requires a value.\n";
    	exit 0;
    }elsif($ARGV[1] eq "-a"){
    	$message=$ARGV[3];
    	abeforcommit();
    }else{
    	$message=$ARGV[2];
    }
	commit($message);
}

#log operation
if($ARGV[0] eq "log"){
	logshow();
}

#show operation
if($ARGV[0] eq "show"){
	show($ARGV[1]);
}

#delete file
if($ARGV[0] eq "rm"){
	@files=();
	shift @ARGV;
	foreach my $file (@ARGV){
		if($file =~ /^[a-zA-Z0-9]/ and $file =~ /^([a-zA-Z0-9\._-]+)$/){
			push @files, $file;
		}
	}
	if(($ARGV[0] eq "--force" and $ARGV[1] eq "--cached") or ($ARGV[0] eq "--cached" and $ARGV[1] eq "--force")){
		removeCachedForce(@files);
	}elsif($ARGV[0] eq "--cached"){
		removeCache(@files);
	}elsif($ARGV[0] eq "--force"){
		removeForce(@files);
	}else{
		removeFile(@files);
	}
}

#Status show
if($ARGV[0] eq "status"){
	status_show();
}

#Branch operation
if($ARGV[0] eq "branch"){
	if(@ARGV == 1){
		opendir(REFS, "\.legit/refs") or die "Can not open index file \.legit/refs.\n";
		my @refs = readdir REFS;
		if(@refs == 2){
			print "legit.pl: error: your repository does not have any commits yet\n";
			exit;
		}
		open(DATA, "<\.legit/HEAD") or die "Fail to open file\n";
		@branches = ();
		$head="";
		$res_str = "";
		while(<DATA>){
			if($_ =~ /^(\*)/){
				$_ =~ s/(\*)//g;
				$head = $_;
			}
			if(!($_ =~ /(\n)$/)){
				$_ .= "\n";
			}
			push @branches, $_;
		}
		foreach my $branch (sort{$a cmp $b} @branches){
			chomp($branch);
			if($head eq $branch){
				$res_str .= "$head\n";
			}else{
				$res_str .= "$branch\n"
			}
		}
		print "$res_str";
		close DATA;
		exit 0;
	}
	if($ARGV[1] eq '-d'){
		if($ARGV[2] eq "master"){
			print "legit.pl: error: can not delete branch 'master'\n";
			exit 0;
		}
		open(DATA, "<\.legit/HEAD") or die "Fail to open file\n";
		$dir = "\.legit/refs/$ARGV[2]";
		rmdir_deep($dir);
		my $flag = 0;
		while(<DATA>){
			chomp($_);
			if($_ ne $ARGV[2]){
				$str.="$_\n";
			}else{
				$flag = 1;
			}
		}
		close DATA;
		if($flag == 0){
			print "legit.pl: error: branch '$ARGV[2]' does not exist\n";
			exit 0;
		}
		open(OUT, ">\.legit/HEAD") or die "Fail to open file\n";
		print OUT $str;
		close OUT;
		print "Deleted branch '$ARGV[2]'\n";
	}else{
		open(DATA, "<\.legit/HEAD") or die "Fail to open file\n";
		while(<DATA>){
			chomp($_);
			if($_ =~ /^(\*)/){
				$_ =~ s/(\*)//g;
			}
			if($_ eq $ARGV[1]){
				print "legit.pl: error: branch '$ARGV[1]' already exists\n";
				exit 0;
			}
		}
		close DATA;
		branch($ARGV[1]);
	}
}

#Checkout operation
if($ARGV[0] eq "checkout"){
	checkout($ARGV[1]);
}

#Merge operation
if($ARGV[0] eq "merge"){
	merge($ARGV[1]);
}

if($ARGV[0] eq "ancestor"){
	$name = thecommonancestor("\.master\.1", "b1");
	if($name eq ""){
		$name = thecommonancestor("b1", "\.master\.1");
	}
	print "$name\n";
}

#Sub program: initialising a repository.
sub init{
	$dir=".legit";
	if(-d $dir){
		print "legit.pl: error: .legit already exists\n";
		exit 0;
	}else{
		$jud=mkdir($dir);
		if($jud == 1){
			#log file
			$log=".legit/log";
			#HEAD file
			$HEAD=".legit/HEAD";
			#index file
			$index=".legit/index";
			#master file
			$master=".legit/master";
			
			$repository = ".legit/repo";
			$ref = ".legit/refs";
			mkdir($repository);
			mkdir($ref);
			open(LOG, ">$log") or die "Cannot open log file.\n";
			open(HEAD, ">$HEAD") or die "Cannot open HEAD file.\n";
			open(INDEX, ">$index") or die "Cannot open index file.\n";
			open(MASTER, ">$master") or die "Cannot open master file.\n";
			print HEAD "\*master\n";
			close MASTER;
			close INDEX;
			close HEAD;
			close LOG;
			print "Initialized empty legit repository in .legit\n";
		}else{
			print "Fail to initialize empty legit repository in .legit\n";
		}
	}
}

#add file to repository-.legit
sub add{
	@params=@_;
	if(!(-d ".legit")){
		print "legit.pl: error: no .legit directory containing legit repository exists\n";
		exit 0;
	}
	$cache=".legit/cache";
	if(!(-d $cache)){
		mkdir($cache);
	}
	$index=".legit/index";
	truncate $index, 0; 
	for($i=1;$i<@params;$i=$i+1){
		if((-e "$cache/$params[$i]") and !(-e -e $params[$i])){
			open(Data, ">>$index") or die "Cannot open a file.\n";
			print Data $params[$i]."\n";
		    exit 0;
	    }
		if(-e $params[$i]){
			if($params[$i] =~ /^[a-zA-Z0-9]/ and $params[$i] =~ /^([a-zA-Z0-9\._-]+)$/){
			    $index=".legit/index";
			    open(Data, ">>$index") or die "Cannot open a file.\n";
				print Data $params[$i]."\n";
				copy($params[$i], $cache);
			}else{
				print "The file $params[$i] format is wrong.\n";
			}
		}else{
			print "legit.pl: error: can not open '$params[$i]'\n";
			exit 0;
		}
	}
}

#Add contents before commit.
sub abeforcommit{
	my $cache=".legit/cache";
	opendir(DIR, $cache) or die "Can not open index file $cache.\n";
	my @dirs = readdir DIR;
	foreach my $file (@dirs){
		if($file =~ /^[a-zA-Z0-9]/ and !($file =~ /[^a-zA-Z0-9\._-]/)){
			copy($file, $cache);
		}
	}
	close DIR;
}

#Commit operation.
sub commit{
	@params=@_;
	$rep=".legit/repo/";
	$cache=".legit/cache";
	$ref=".legit/refs/";
	$relation = ".legit/relations";
	$index = ".legit/index";
	$log = ".legit/log";

	#Reading file names from directory.
	@files=();
	opendir(DIR, $cache) or die "Can not open directory $cache.\n";
	@dira=readdir DIR;
	close DIR;
	foreach my $dfile (@dira){
		if($dfile =~ /^[a-zA-Z0-9]/ and !($dfile =~ /[^a-zA-Z0-9\._-]/)){
			my $newdir = $cache."/$dfile";
			push @files, $dfile;
		}
	}
	
	#Finding target filename.
	$filename = current_pointing_filename();
	#Get file name which generates new file.
	$fromFile = specified_file($filename);
	$rname="\.$filename";
	
	#Find the maximal index.
	$max_index = max_index($filename);
	if($max_index >= 0){
		my $cmpdir="\.legit/repo";
		opendir(SDATA, $cache) or die "Can not open directory $cache.\n";
		opendir(CDATA, $cmpdir) or die "Can not open directory $cmpdir.\n";
		@sdata=readdir SDATA;
		@cdata=readdir CDATA;
		$ssnum=@sdata;
		$ccnum=@cdata;
		close CDATA;
		close SDATA;
		if($ssnum == $ccnum and compFile("\.legit/index", "\.legit/refs/\.$filename\.$max_index/index") == 1){
			$flag=0;
			for($j=0;$j<$ssnum;$j=$j+1){
				if($sdata[$j]=~ /^[a-zA-Z0-9]/ and !($sdata[$j] =~ /[^a-zA-Z0-9\._-]/) 
			  	   and $cdata[$j]=~ /^[a-zA-Z0-9]/ and !($cdata[$j] =~ /[^a-zA-Z0-9\._-]/)
			   	   and (compFile($cache."/$sdata[$j]", $cmpdir."/$cdata[$j]") == 0
			   	   or $sdata[$j] ne $cdata[$j])){
			    	$flag=1;
			    	last;
				}
			}
			if($flag == 0){
				print "nothing to commit\n";
			    exit 0;
			}
		}
	}
	$newref=$ref."$rname.$count";
	mkdir $newref;
	unlink glob "$rep\*";
	foreach my $file(@files){
		copy($cache."/$file", $rep);
	}
	
	#copy dirs to newref
	copydirectory("\.legit/cache", "$newref//cache");
	copydirectory("\.legit/repo", "$newref//repo");
	mkdir "$newref//files";
	foreach my $file (<*>){
		if(-e $file){
			copy($file, "$newref//files");
		}
	}
	
	#Log operation.
	$log=".legit/log";
	$scalar=0;
	open(LOG, "<$log") or die "Cannot open log file.\n";
	while(<LOG>){
		$scalar++;
	}
	close LOG;
	open(LOG, ">>$log") or die "Cannot open log file.\n";
	$str="$scalar $params[0]\n";
	print LOG $str;
	close LOG;
	copy($index, "$newref//index");
	copy($log, "$newref//log");
	print "Committed as commit $scalar\n";
	#Change master file
	if($filename eq "master"){
		$master = "\.legit/master";
		open(MASTER, ">$master") or die "Cannot open master file.\n";
		print MASTER "$rname.$count";
		close MASTER;
	}
	if(-e $relation){
		$toFile = "$rname.$count";
		writeToRelation($fromFile, $toFile);
	}else{
		open(RELA, ">$relation") or die "Fail to create relation file.\n";
		close RELA;
	}
}

#Log operation.
sub logshow{
	 $log=".legit/log";
	 open(Data, "<$log") or die "Cannot open log file.\n";
	 @logs=<Data>;
	 $num=@logs;
	 $num -= 1;
	 for($i=$num;$i>=0;$i=$i-1){
	 	print "$logs[$i]";
	 }
	 close Data;
}

#Show contents of file.
sub show{
	@params=@_;
	@data=split(":", $params[0]);
	$logfile = ".legit/log";
	open(FDATA, "<$logfile") or die "Can not open log file.\n";
	@ffile = <FDATA>;
	$ncount=@ffile;
	if($ncount == 0){
		print "legit.pl: error: your repository does not have any commits yet\n";
		exit 0;
	}
	$goalfile="";
	$head_file = current_pointing_filename();
	#Find target file.
	if($data[0] =~ /[0-9]+/){
		$head_file = "\.$head_file\.$data[0]";
		$repository="\.legit/refs/$head_file/repo";
		opendir(DIR, $repository) or die "legit.pl: error: unknown commit '$data[0]'\n";
		@dira=readdir DIR;
		close DIR;
		foreach my $dfile (@dira){
			if($dfile =~ /^($data[1])/){
				$goalfile=$dfile;
				last;
			}
		}
		if($goalfile eq ""){
			print "legit.pl: error: '$data[1]' not found in commit $data[0]\n";
			exit 0;
		}
	}else{
		$repository="\.legit/cache";
		opendir(DIR, $repository) or die "Can not open directory $repository.\n";
		@dira=readdir DIR;
		close DIR;
		foreach my $dfile (@dira){
			if($dfile =~ /^($data[1])/){
				$goalfile=$dfile;
				last;
			}
		}
		if($goalfile eq ""){
			print "legit.pl: error: '$data[1]' not found in index\n";
			exit 0;
		}
	}
	$goalfile = $repository."/$goalfile";
	open(FILE, "<$goalfile") or die "Can not open file $goalfile.\n";
	while(<FILE>){
		print "$_";
	}
	close FILE;
}

#Delete file.
sub removeFile{
	@param=@_;
	$cache=".legit/cache/";
	$rep = ".legit/repo/";
	$refs = ".legit/refs/";
	$head_file = current_pointing_filename();
	my $index = max_index($head_file);
	
	foreach my $file (@param){
		if(!(-e $rep."/$file") and !(-e $cache."$file")){
			print "legit.pl: error: '$file' is not in the legit repository\n";
			exit 0;
		}
		if(-e $cache.$file and -e $file){
			if(!(-e $refs.".$head_file.$index"."/repo/$file")){
				print "legit.pl: error: '$file' has changes staged in the index\n";
				exit 0;
			}
			if(compFile($cache."$file",$refs.".$head_file.$index"."/repo/$file") == 0 and
			   compFile($cache."$file","$file") == 0){
				print "legit.pl: error: '$file' in index is different to both working file and repository\n";
				exit 0;
			}
			if(compFile($cache."$file",$refs.".$head_file.$index"."/repo/$file") == 0){
				print "legit.pl: error: '$file' has changes staged in the index\n";
				exit 0;
			}
			if(compFile($refs.".$head_file.$index"."/repo/$file","$file") == 0){
				print "legit.pl: error: '$file' in repository is different to working file\n";
				exit 0;
			}
			unlink $file;
			unlink $cache.$file;
		}else{
			print "legit.pl: error: '$file' is not in the working file\n";
			exit 0;
		}
	}
}

#Delete file from cache.
sub removeCache{
	my @param=@_;
	$cache="\.legit/cache/";
	$rep = "\.legit/repo/";
	foreach my $file (@param){
		if(!(-e $cache."$file")){
			print "legit.pl: error: '$file' is not in the legit repository\n";
			exit 0;
		}else{
			if((-e $cache."$file") 
			   and (-e $rep."/$file")
			   and compFile($cache."$file",$rep."/$file") == 0
			   and compFile($cache."$file","$file") == 0){
				print "legit.pl: error: '$file' in index is different to both working file and repository\n";
		    	exit 0;
			}
		}
		my $dir = $cache."$file";
		unlink $dir or warn "Failed on deleting file $dir";
	}
}

#Delete by force.
sub removeForce{
	@param=@_;
	$cache=".legit/cache/";
	foreach my $file (@param){
		if(-e $cache.$file){
			unlink $file;
			unlink $cache.$file;
		}else{
			print "legit.pl: error: '$file' is not in the legit repository\n";
			exit 0;
		}
	}
}

#Delete by force from cache.
sub removeCachedForce{
	@param=@_;
	$cache=".legit/cache/";
	foreach my $file (@param){
		if(-e $cache.$file){
			unlink $cache.$file;
		}else{
			print "legit.pl: error: '$file' is not in the legit repository\n";
			exit 0;
		}
	}
}

#status show
sub status_show{
	%hash=();
	@current_dir =<*>;
	my $cache="\.legit/cache/";
	my $rep = "\.legit/repo/";
	my $refs = "\.legit/refs/";
	my $head_file = current_pointing_filename();
	my $index = max_index($head_file);
	opendir(CACHE, $cache) or die "Can not open directory $cache.\n";
	@caches=readdir CACHE;
	if(@caches == 2){
		foreach my $file (@current_dir){
			$hash{$file}="untracked";
		}
	}
	
	foreach my $file (@current_dir){
		if(-e $cache.$file || @caches == 0){
			if(-e $rep."$file"){
				if(compFile($cache."$file",$rep."$file") == 0){
					if(compFile($cache."$file","$file") == 0){
						$hash{$file}="file changed, different changes staged for commit";
					}else{
						$hash{$file}="file changed, changes staged for commit";
					}
				}else{
					if(compFile($cache."$file","$file") == 0){
						$hash{$file}="file changed, changes not staged for commit";
					}else{
						$hash{$file}="same as repo";
					}
				}
			}else{
				if(compFile($cache."$file","$file") == 1){
					$hash{$file}="added to index";
				}
			}
		}else{
			if(!(-e $rep."$file")){
				$hash{$file}="untracked";
			}
		}
	}
	
	opendir(REP, $refs.".$head_file.$index"."/repo") or die "Can not open repo directory.\n";
	@rep=readdir REP;
	shift @rep;
	shift @rep;
	close REP;
	foreach my $file (@rep){
		if(!(exists $hash{$file})){
			if(!(-e $file)){
				if(-e $cache.$file){
					$hash{$file}="file deleted";
				}else{
					$hash{$file}="deleted";
				}
			}
		}
	}
	
	#Show the content of status
	foreach my $key (sort{$a cmp $b} keys %hash){
		print "$key - $hash{$key}\n";
	}
}

#Create a branch.
sub branch{
	@param=@_;
	my $refs = "\.legit/refs/$param[0]";
	my $fromFile = current_pointing_filename();
	$fromFile = specified_file($fromFile);
	$toFile = $param[0];
	if(-d $refs){
		print "$param[0] exists.\n";
		exit 0;
	}
	my $jud=mkdir($refs);
	if($jud == 1){
		copydirectory("\.legit/cache", "$refs//cache");
		copydirectory("\.legit/repo", "$refs//repo");
		mkdir "$refs//files";
		foreach my $file (<*>){
			if(-e $file){
				copy($file, "$refs//files");
			}
		}
	}else{
		print "Fail to create the branch $param[0]\n";
	}
	$head = "\.legit/HEAD";
	open(HEAD, ">>$head") or die "Cannot open head file.\n";
	print HEAD "$param[0]\n";
	writeToRelation($fromFile, $toFile);
}

#Checkout operation.
sub checkout{
	@param=@_;
	my $name = "";
	my $ref = "";
	if($param[0] eq "master"){
		open(MASTER, "<\.legit/master") or die "Can not open master file.\n";
		$name = <MASTER>;
		chomp($name);
	}else{
		$name = specified_file($param[0]);
	}
	$refs = "\.legit/refs/$name";
	if(-d "$refs"){
		open(DATA, "<\.legit/HEAD") or die "Can not open head file.\n";
		my $str = "";
		while(<DATA>){
			chomp($_);
			if($_ eq $param[0]){
				$str .= "\*"
			}
			if($_ =~ /^(\*)/){
				$_ =~ s/(\*)//g;
			}
			$str .= "$_\n";
		}
		close DATA;
		open(OUT, ">\.legit/HEAD") or die "Can not open head file.\n";
		print OUT $str;
		close OUT;
		copydirectory("\.legit/refs/$name/cache", "\.legit/cache");
		copydirectory("\.legit/refs/$name/repo", "\.legit/repo");
		foreach my $file (<*>){
			if((-e $file) and ($file ne "legit")){
				unlink $file;
			}
		}
		$brandir = "\.legit/refs/$name/files";
		opendir(BRANDIR, $brandir) or die "Can not open directory $brandir.\n";
		my @brandirs = readdir BRANDIR;
		my $curdir = getcwd;
		foreach my $file (@brandirs){
			if($file ne "legit"){
				copy($brandir."//$file", $curdir);
			}
		}
		close BRANDIR;
		print "Switched to branch '$param[0]'\n";
	}else{
		print "legit.pl: error: unknown branch '$param[0]'\n";
	}
}

#Merge operation.
sub merge{
	@param=@_;
	$name = $param[0];
	
	my $file1 = specified_file("master");
	my $file2 = specified_file($name);
	my $ancestor = thecommonancestor($file1, $file2);
	if($ancestor eq ""){
		$ancestor = thecommonancestor($file2, $file1);
	}
	#Finding the last commit file.
	$max_index = max_index($name);
	$name ="\."."$name"."\.$max_index" if($max_index > 0);

	#Merge files in master and branch.
	foreach my $file (<*>){
		if((-e $file) and ($file ne "legit")){
			my $ref = mergeFile($file, "\.legit/refs/$name/files/$file", $ancestor);
			if($ref == 0){
				print "legit.pl: error: These files can not be merged:\n$file";
				exit 0;
			}else{
				print "Auto-merging $file\n";
			}
		}
	}
}

#Calculate the maximal index.
sub max_index{
	my @indexes=@_;
	$head=$indexes[0];
	
	#Finding the maximal index.
	my $rep = "\.legit/refs/";
	$count=0;
	opendir(DIR, $rep) or die "Can not open directory $rep.\n";
	#Calculate the number of files whose name contains 'repository'.
	$count=0;
	@dira=readdir DIR;
	close DIR;
	foreach my $dfile (@dira){
		if($dfile =~ /.*($head).*/){
			$count++;
		}
	}
	return $count - 1;
}

#Compare contents of two files.
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

#Take current pointing filename.
sub current_pointing_filename{
	open(DATA, "<\.legit/HEAD") or die "Can not open head file.\n";
	$filename="";
	while(<DATA>){
		chomp($_);
		if($_ =~ /^(\*)/){
			$filename=$_;
			last;
		}
	}
	close DATA;
	$filename =~ s/(\*)//g;
	return $filename;
}

#Copy from one directory to another one.
sub copydirectory{
	my @param=@_;
	$dir1 = $param[0];
	$dir2 = $param[1];
	if(!(-d $dir2)){
		mkdir $dir2;
	}else{
		opendir(DIR2, $dir2) or die "Can not open directory $dir2.\n";
		@dirs=readdir DIR2;
		foreach my $file (@dirs){
			if(-e $file){
				unlink $dir2."//$file";
			}
		}
		close DIR2;
	}
	opendir(DIR, $dir1) or die "Can not open directory $dir1.\n";
	@dira=readdir DIR;
	close DIR;
	foreach my $file (@dira){
		copy("$dir1"."//$file", $dir2);
	}
}

#Delete directory containing files.
sub rmdir_deep {
    my $dir = shift;
    return if (!-e $dir);
    my $D;
    opendir $D, $dir;
    my @D = readdir $D;
    close $D;
    for my $d(@D) {
        next if ($d =~ /^.{1,2}$/);
        my $p = "$dir/$d";
        if (-f $p){
            unlink $p;
            next;
        }
        rmdir_deep($p);
    }
    rmdir($dir);
}

#Merge operation
sub mergeFile{
	@param = @_;
	my $file1 = $param[0];
	my $file2 = $param[1];
	my $common_ancestor = $param[2];
	
	$common_ancestor ="\.legit/refs/$common_ancestor/files/$file1";
	#Taking contents from files.
	open(MASTER, "<$common_ancestor") or die "Can not open master file.\n";
	open(FILE1, "<$file1") or die "Can not open master $file1.\n";
	open(FILE2, "<$file2") or die "Can not open master $file2.\n";
	my @branch1_arrays = <FILE1>;
	my @branch2_arrays = <FILE2>;
	my @masters = <MASTER>;
	close FILE2;
	close FILE1;
	close MASTER;
	$i=0;
	$str="";
	for(;$i<@masters;$i=$i+1){
		chomp($masters[$i]);
		chomp($branch1_arrays[$i]);
		chomp($branch2_arrays[$i]);
		if(($masters[$i] ne $branch1_arrays[$i]) and ($masters[$i] ne $branch2_arrays[$i])){
			return 0;
		}elsif($masters[$i] ne $branch1_arrays[$i]){
			$str .= "$branch1_arrays[$i]\n";
		}elsif($masters[$i] ne $branch2_arrays[$i]){
			$str .= "$branch2_arrays[$i]\n";
		}else{
			$str .= "$masters[$i]\n";
		}
	}
	for(;$i<@branch1_arrays;$i=$i+1){
		$str .= "$branch1_arrays[$i]\n";
	}
	for(;$i<@branch2_arrays;$i=$i+1){
		$str .= "$branch2_arrays[$i]\n";
	}
	
	#Write new content to the file.
	chomp($str);
	open(OUT, ">$file1") or die "Can not open master $file1.\n";
	print OUT $str;
	close OUT;
}

#Find the cloest common ancestor.
sub thecommonancestor{
	my @files = @_;
	my $file1 = $files[0];
	my $file2 = $files[1];
	
	$front = $hash{$file1}{"front"};
	@fronts = ();
	@fronts = split(" ", $front) if($front ne " ");
	$result = "";
	foreach my $ffile (@fronts){
		if(findFile($ffile, $file2) == 1){
			return $ffile;
		}
		$result = thecommonancestor($ffile, $file2);
	}
	return $result;
}

sub findFile{
	my @ffiles = @_;
	my $sfile1 = $ffiles[0];
	my $sfile2 = $ffiles[1];
	
	$post = $hash{$sfile1}{"post"};
	@posts = split(" ", $post);
	foreach my $file (@posts){
		if($file eq $sfile2){
			return 1;
		}
	}
	return 0;
}

#Find specified file.
sub specified_file{
	my @file_name = @_;
	my $specified = $file_name[0];
	my $max_index = max_index($specified);
	$goal_file = "\.$specified\.$max_index";
	if($max_index == 0){
		if(-d "\.legit/refs/$goal_file"){
			return $goal_file;
		}else{
			return $specified;
		}
	}
	return $goal_file;
}

#Write to relation file.
sub writeToRelation{
	my @param = @_;
	$file1 = $param[0];
	$file2 = $param[1];
	$relation = "\.legit/relations";
	open(RELA, ">>$relation") or die "Fail to create relation file.\n";
	print RELA "$file1 $file2\n";
	close RELA;
}
