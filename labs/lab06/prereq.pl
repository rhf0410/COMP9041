#!/usr/bin/perl

$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/2018/$ARGV[0].html";
open F, "wget -q -O- $url|" or die;
$courses="";
while ($line = <F>) {
    if($line =~ /.*Prerequisite.*/){
        $line =~ s/^\s+//;
        $line =~ s/<\/p.*//;
        $line =~ s/\.$//;
        @course=split(' ', $line);
        foreach my $name (@course){
            if($name =~ /^[A-Z]{4}[0-9]{4}$/){
                $courses.="$name ";
            }
        }
    }
}

$url = "http://www.handbook.unsw.edu.au/undergraduate/courses/2018/$ARGV[0].html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
    if($line =~ /.*Prerequisite.*/){
        $line =~ s/^\s+//;
        $line =~ s/<\/p.*//;
        $line =~ s/\.$//;
        @course=split(' ', $line);
        foreach my $name (@course){
            if($name =~ /^[A-Z]{4}[0-9]{4}$/){
                $courses.="$name ";
            }
        }
    }
}
$courses =~ s/\s$//;
@preres=split(' ', $courses);
@results = sort @preres;
foreach my $res (@results){
    print "$res\n";
}
