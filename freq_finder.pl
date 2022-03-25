#!/usr/bin/perl
#
# 

use strict;
use POSIX;

# Set hackrf_sweep binary and arguments for each run
my $hsweep = "/usr/bin/hackrf_sweep -f 6:6000 -w 3000 -l 16 -g 24 -1";
#my $hsweep = "/usr/bin/hackrf_sweep -f 6:6000 -w 100000 -l 16 -g 24 -1";

# Command line inputs
# Minimum power to display
my $power = $ARGV[0];
chomp($power);
if ($power =~ /^-/) {
	$power =~ s/^-//;
}

# Number of runs for hackrf_sweep
my $runs = $ARGV[1];
chomp($runs);

if ($runs < "2" || $power == "") {
        print "$0 <power_level> <num_of_sweeps>\n";
	print "The <num_of_sweeps> must be >= 2\n";
	exit;
}

# Primary data hash for collected hackrf_sweep information
my $swDat;

# Run hackrf_sweep and gather information x number of times
while ($runs >= 1) {
	sweep();
	$runs--;
	#sleep(1);
}


# Output data gathered
foreach my $key (sort {$a<=>$b} keys(%$swDat)) {
	if ($swDat->{$key}->{count} > 1) {
		print "freq:$key seen:$swDat->{$key}->{count} avgPower:".ceil($swDat->{$key}->{avgPower})." maxPower:$swDat->{$key}->{maxPower} minPower:$swDat->{$key}->{minPower}\n";
	}
}

# hackrf_sweep data collection
sub sweep {
	open(STDERR, "> /dev/null") or die "unable to open /dev/null for writing\n";
	open(FB, "$hsweep|") or die "unable to open pipe to $hsweep\n";
	while (<FB>) {
		my $line = $_;
		chomp($line);
		my @data;
		my ($elements, $date, $time, $hzL, $hzH, $hzBw, $hzBin, $numSamp, $counter, $curPower);
		@data = split(",", $line);

		$elements = @data;

		# capture date element
		$date = $data[0];
		$date =~ s/^ //;

		# capture time element
		$time = $data[1];
		$time =~ s/^ //;

		# frequency Hz low element
		$hzL = $data[2];
		$hzL =~ s/^ //;
		$hzBin = $hzL;

		# frequency Hz high element
		$hzH = $data[3];

		# frequency bandwidth
		$hzBw = $data[4];

		$numSamp = $data[5];

		# Power elements start at the 6th position of the @data array
		$counter = 6;

		while ($counter < $elements) {
			#print "$date,$time,$hzL,$hzH,$hzBw,$numSamp,$hzBin,$data[$counter]\n";
			$curPower = $data[$counter];
			$curPower =~ s/^ //;
			if ($curPower >= -$power) {
				#print "$date,$time,$hzBin,$curPower\n";
				if (defined($swDat->{$hzBin}->{count})) {
					$swDat->{$hzBin}->{count}++;
				} else {
					$swDat->{$hzBin}->{count} = 1;
				}

				$swDat->{$hzBin}->{sumPower} += $curPower;
				$swDat->{$hzBin}->{avgPower} = $swDat->{$hzBin}->{sumPower} / $swDat->{$hzBin}->{count}; 
				unless (defined($swDat->{$hzBin}->{maxPower})) {
					$swDat->{$hzBin}->{maxPower} = $curPower;
				}
				unless (defined($swDat->{$hzBin}->{minPower})) {
					$swDat->{$hzBin}->{minPower} = $curPower;
				}

				if ($curPower > $swDat->{$hzBin}->{maxPower}) {
					$swDat->{$hzBin}->{maxPower} = $curPower;
				}

				if ($curPower < $swDat->{$hzBin}->{minPower}) {
                                        $swDat->{$hzBin}->{minPower} = $curPower;
                                }
			}
			$counter++;
			$hzBin += $hzBw;
		}
	}
	close(FB);
	close(STDERR);

}
