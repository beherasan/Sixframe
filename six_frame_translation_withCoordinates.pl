#!usr/bin/perl

open(IN1,"gen_code_standard_NCBI.txt") or die "Could not open the file:$!\n";

while(<IN1>)
{
	chomp;
	($c,$a)=(split /\s/)[0,1];
	$triplet{$c}="$a";
}
close IN1;

open(IN,"ToxoDB-42_TgondiiGT1_Genome.fasta") or die "Could not open the file:$!\n";

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
	}
}

foreach $k (keys %hash)
{
	$seq=$hash{$k};
	$type="f";
	sixframe($k,$seq,\%triplet,$type);
	$seq=~tr/ATGC/TACG/;
	$rev=reverse($seq);
	$type="r";
	sixframe($k,$rev,\%triplet,$type);
}


sub sixframe
{
	my ($sid,$sseq,$triplet_ref,$stype)=@_;
	my %codon_new=%{$triplet_ref};
	$l=length($sseq);
	for($i=0;$i<3;$i++)
	{
		$pep="";
		$count=1;
		for($j=$i;$j<($l-1);$j+=3)
		{
			if ($pep eq "" && $stype eq "f")
			{
				$start_pos=$j+1;
			}
			if ($pep eq "" && $stype eq "r")
			{
				$start_pos=($l-$j);
			}
			$codon=substr($sseq,$j,3);
			if(exists $codon_new{$codon})
			{
				$p=$codon_new{$codon};
				if($p ne "*")
				{				
					$pep.="$p";
				}
				if($p eq "*" || ($l-($j+2))<=3)
				{
					if(length($pep)>7)
					{
						$name=$sid."_".$i."_".$stype."$count";
						$name2=$stype.$count;
						if ($stype eq "f" && $p eq "*")
						{
							$end_pos=$j;
						}
						if($stype eq "f" && ($l-($j+2))<=3)
						{
							$end_pos=$j+3;
						}
						if ($stype eq "r" && $p eq "*")
						{
							$end_pos=$l-($j-1);
						}	
						if($stype eq "r" && ($l-($j+2))<=3)
						{
							$end_pos=$l-($j+2);
						}	
						print ">gi|$name|ref| $sid #PS_$start_pos-$end_pos\_$stype$i\n$pep\n";
					}
					$pep="";
					$count++;
				}
			}
		}
	}
}
