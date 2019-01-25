#!/usr/bin/perl

###############################################################################
## This program will help to remove the sequences with no tryptic peptides ####
##       Usage: perl tryptic_six_frame.pl input(in one line .fasta)   	   ####
###############################################################################

$infile=$ARGV[0];
open(IN,"$infile") or die "Could not open the file:$!\n";

while(<IN>)
{
	chomp;
	if(/^>/)
	{
		$id = $_;
	}
	else
	{
		$seq=$_;
		$_ =~s/([K|R])([^P])/$1#$2/g;
		@line = (split /\#/);
		$count=0;
		foreach $k (@line)
		{
			if(length($k) >= 7)
			{
				$count++;
			}
		}
		if($count >= 1)
		{
			print "$id\n$seq\n";
		}
	}
}
