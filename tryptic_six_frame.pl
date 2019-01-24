#!/usr/bin/perl


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
		#print "$_\n";
		$_=~s/([K|R])([^P])/#$2/g;
		#print "$_\n";
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
			print "$id\n$_\n";
		}
	}
}
