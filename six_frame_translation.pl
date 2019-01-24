#!usr/bin/perl

open(IN1,"gen_code_standard_NCBI.txt") or die "Could not open the file:$!\n";

while(<IN1>)
{
	chomp;
	($c,$a)=(split /\s/)[0,1];
	$triplet{$c}="$a";
}
close IN1;

open(IN,"Malnad_gidda-scaffolds.fa") or die "Could not open the file:$!\n";

while(<IN>)
{
	chomp;
	if(/^>/)
	{
		$id=(split /\s/)[0];
		$id=~s/\>//;
	}
	else
	{
		if(/[A-Z]/)
		{
			$hash{$id}.=$_;
		}
=start
		else
		{
			$type="f";
			sixframe($id,$seq,\%triplet,$type);
			$seq=~tr/ATGC/TACG/;
			$rev=reverse($seq);
			#print "santosh$rev\n\n";
			$type="r";
			sixframe($id,$rev,\%triplet,$type);
		}
=cut
	}
}

foreach $k (keys %hash)
{
	$seq=$hash{$k};
	$type="f";
	sixframe($k,$seq,\%triplet,$type);
	$seq=~tr/ATGC/TACG/;
	$rev=reverse($seq);
	#print "santosh$rev\n\n";
	$type="r";
	sixframe($k,$rev,\%triplet,$type);
}


sub sixframe
{
	my ($sid,$sseq,$triplet_ref,$stype)=@_;
	#print "$sid\n$sseq\n";
	my %codon_new=%{$triplet_ref};
	$l=length($sseq);

	for($i=0;$i<3;$i++)
	{
		$pep="";
		$count=1;
		for($j=$i;$j<($l-1);$j+=3)
		{
			$codon=substr($sseq,$j,3);
			if(exists $codon_new{$codon})
			{
				$p=$codon_new{$codon};
					
				unless($p eq "*")
				{				
					$pep.="$p";
				}
				else

				{
					if(length($pep)>7)
					{
						$name=$sid."_".$i."_".$stype."$count";
						$name2=$stype.$count;
						#print "$name\n$pep\n";
						print ">gi|$name|ref|$name| $name###$name\n$pep\n";
					}
					$pep="";
					$count++;
				}
			}
		}
		#print "completed a frame\n";
	}
}
