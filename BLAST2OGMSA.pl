#!/usr/bin/perl
#
#AUTHOR
#Guiqi Bi :fenghen360@126.com
#VERSION
#BLAST@OGMSA v1.0
#COPYRIGHT & LICENCE
#This script is free software; you can redistribute it and/or modify it.
#This  script is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of merchantability or fitness for a particular purpose.

my $USAGE = 	"\nusage: perl BLAST2OGMSA.pl -method=[Gblocks|trimAl|BMGE|noisy] <file.aln> <seqdump.txt> <species_name> <output.fasta>\n";

my $method;
my $aln = $ARGV[1];
my $seqdump = $ARGV[2];
my $species = $ARGV[3];
my $out = $ARGV[4];

foreach my $paras (@ARGV){
	if ($paras=~/-help/){
		print $USAGE;
		exit;
	}
	if ($paras=~/-h/){
		print $USAGE;
		exit;
	}
	if ($paras=~/method/){
	    $method=(split "=", $paras)[1];
	}
}
if (!$ARGV[1]){
		print $USAGE;
		exit;
		print "Please provide the raw blast alignment file download from MSA viewer!\n"
	}
if (!$ARGV[2]){
		print $USAGE;
		exit;
		print "Please provide the raw sequence file download from blastn results.\n"
	}
if (!$ARGV[3]){
		print $USAGE;
		exit;
		print "Please provide the species name that was inputted as the query sequence.\n"
	}
if (!$ARGV[4]){
		print $USAGE;
		exit;
		print "Please provide the name of output file.\n"
	}
		

#-------------------------------------------------------------------------------------------

my @list = ();
open (LIST,$seqdump) or die "Cannot open file $seqdump: $!\n";
while (<LIST>) {    
	    if (/^>(.*)/) {
		my @y = split /\|/, $1;
        my @w = split /\s/, $y[1];
		my $id = "$w[0]-$w[1]-$w[2]-$w[3]";
		push @list, $id;
    }
 }
close LIST;
#-------------------------------------------------------------------------------------------
my %seq = ();
my $sid = ();
my $turnoff;
open (IN, $aln) or die "Cannot open file $aln: $!\n";;
while (<IN>) { 
    if (/^\>(\S+)/) {
        $sid = $1;
        my @w = split /\|/, $sid;
        $sid = $w[1];
		if (exists $seq{$sid}){$turnoff=0;} else{$turnoff=1;}
        }
	else {
       if($turnoff==1){$seq{$sid} .= $_;}
    }
}
close IN;
 
open (OUT, ">$aln.temp") or die "Cannot create file $outs: $!\n";
foreach my $id (keys %seq) {
    print OUT ">$id\n";
    print OUT $seq{"$id"};
}
close OUT;

#-------------------------------------------------------------------------------------------
my @trimed=glob("*.temp");
foreach my $trimed(@trimed){
         if("$method" eq "Gblocks"){system("./bin/Gblocks $trimed out");}
		 if("$method" eq "trimAl"){system("./bin/trimal -in $trimed -out ${trimed}-gb -fasta -htmlout $trimed.html -automated1");}
		 if("$method" eq "BMGE"){system("java -jar ./bin/BMGE.jar -i $trimed -t DNA -s YES -of ${trimed}-gb -oh $trimed.html");}
		 if("$method" eq "noisy"){system("./bin/noisy $trimed");}
		 unlink ("$trimed");
}

#-------------------------------------------------------------------------------------------

if("$method" eq "Gblocks"){
my @gb=glob("*.temp-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^\w{10}\s/i){
				              $delete++;
				              $_=~s/\s//g;
							  print GBOUT "$_\n";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb.".out";
$temp_name2=~s/temp-gb\.out/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "trimAl"){
my @gb=glob("*.temp-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/temp-gb/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "BMGE"){
my @gb=glob("*.temp-gb");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/temp-gb/fasta/g;
rename("$gb.out","$temp_name2");
}}

if("$method" eq "noisy"){
my @gb=glob("*.fas");
foreach my $gb(@gb){
        my $delete=0;
        open(GB, "<$gb")||die "Can't open $in:$!\n";
		open(GBOUT, ">>$gb.out")||die "Can't open $in:$!\n";
        while(<GB>){
		          
		          if(/^>/){$_=~s/ //g;print GBOUT "$_";}
				  elsif(/^[A|T|C|G|N|-]+\n/i){
				              $delete++;
				              print GBOUT "$_";
							  }
		          
		}
close(GB);
close(GBOUT);
if ($delete==0){unlink("$gb.out");}
unlink ("$gb");
my $temp_name2=$gb;
$temp_name2=~s/_out\.fas/\.fasta/g;
rename("$gb.out","$temp_name2");
}}
#-------------------------------------------------------------------------------------------
my %seq2 = ();
my $sid2 = ();
open (INI, "$aln.fasta") or die "Cannot open file $aln.fasta: $!\n";;
while (<INI>) {
    if (/^\>(\S+)/) {
	    chomp;
        $sid2 = $1;
        #my @w = split /\|/, $sid2;
        #if (@w > 2) {
            #$sid2 = $w[2];   
        #} else {
         #   $sid2 = $w[0];
        #}
    } 
	else {
        $seq2{$sid2} .= $_;
    }
}
close INI;


my @query = keys %seq2;
my $end_name;
#foreach (@query){
#if(m/Query/){$end_name = $_;}
#}
#open (YOU, ">$out") or die "Cannot create file $outs: $!\n";
#print YOU ">$species\n";
#print YOU $seq2{"$end_name"};
#close YOU;

open (OUT, ">$out") or die "Cannot create file $outs: $!\n";
foreach my $id (@list) {
	my @new= split /-/,$id;
    print OUT ">$new[1]_$new[2]_$new[3]\n";
    print OUT $seq2{"$new[0]"};
}
close OUT;
