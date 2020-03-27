#!/usr/bin/perl -w

open(DATA, $ARGV[0]) or die "Can not open file $ARGV[0]";
@perl_content=();
while(<DATA>){
	$str=$_;
	chomp($str);
	if($str eq "#!/bin/bash"){
		$str = "#!/usr/bin/perl -w";
	}elsif($str =~ "echo.*"){
		$nstr = $str;
		$nstr =~ s/echo/print/g;
		$nstr =~ s/print /print "/g;
		$nstr .= "\\n\";";
		$str = $nstr;
	}elsif($str =~ /^[a-zA-Z_]([a-zA-Z_])*=([0-9]+)$/){
		$nstr = $str;
		$nstr =~ s/(\w+)=(\d)/\$$1 = $2/g;
		$nstr .= ";";
		$str = $nstr;
	}elsif($str =~ /^([ ]*while)/){
		$nstr = $str;
		$nstr =~ s/[(]+/(/g;
		$nstr =~ s/[)]+/)/g;
		$nstr =~ s/[(]/(\$/g;
		$nstr =~ s/< /< \$/g;
		$nstr =~ s/<= /<= \$/g;
		$nstr =~ s/> /> \$/g;
		$nstr =~ s/>= />= \$/g;
		$nstr =~ s/\$(\d+)/$1/g;
		$nstr .= " {";
		$str = $nstr;
	}elsif($str =~ /[ ]*done/){
		$str =~ s/done/}/g;
	}elsif($str =~ /[ ]*do/){
		$str =~ s/do//g;
	}elsif($str =~ /[ ]*then/){
		$str =~ s/then//g;
	}elsif($str =~ /(fi)$/){
		$str =~ s/fi/}/g;
	}elsif($str =~ /.*[\$].*[\+].*/){
		$nstr = $str;
		$nstr =~ s/[(]+//g;
		$nstr =~ s/[)]+//g;
		$nstr =~ s/(\w+)=\$(\w+)/\$$1 = \$$2/g;
		$nstr =~ s/\$(\d+) \* (\w+)/$1 \* \$$2/g;
		$nstr =~ s/([a-zA-Z]+) \+ ([a-zA-Z]+)/$1 \+ \$$2/g;
		$nstr .= ";";
		$str = $nstr;
	}elsif($str =~ /.*if.*/){
		$nstr = $str;
		$nstr =~ s/[(]+/(/g;
		$nstr =~ s/[)]+/)/g;
		$nstr =~ s/[(]/(\$/g;
		$nstr =~ s/\* /\* \$/g;
		$nstr =~ s/\+ /\+ \$/g;
		$nstr =~ s/== (\D+)/== \$$1/g;
		$nstr =~ s/== (\d+)/== $1/g;
		$nstr .= " {";
		$str = $nstr;
	}elsif($str eq ""){
		$str="";
	}elsif($str =~ /([a-zA-Z]+)=[\$][\(]/){
		$nstr = $str;
		$nstr =~ s/(\w+)=/\$$1 = /g;
		$nstr =~ s/[(]+//g;
		$nstr =~ s/[)]+//g;
		$nstr .= ";";
		$str = $nstr;
	}elsif($str =~ /(else)$/){
		$nstr = $str;
		$nstr =~ s/else/} else {/g;
		$str = $nstr;
	}
	else{
		$nstr = $str;
		$nstr =~ s/(\w+)=\$([a-zA-Z]+)/\$$1 = \$$2;/g;
		$nstr =~ s/\$(\d+) \* (\w+)/$1 \* \$$2/g;
		$str = $nstr;
	}
	push @perl_content, $str if($str ne "");
}
foreach my $con (@perl_content){
	print "$con\n";
}
close DATA;
