#!/usr/bin/perl

#----------------------------------------------------------------------
# tmix
# 
# Copyright May 08, 2008, The University of North Carolina at Chapel Hill
# 
# All rights reserved.  No part of this software may be sold or
# distributed in any form or by any means without the prior written
# permission of the Department of Computer Science, University of North
# Carolina at Chapel Hill.  Distribution and use of this software is
# subject to the Software License Agreement incorporated in this
# software. By having, retaining or using a copy of this software, you
# agree to be subject to  the terms of the Software License Agreement.
# 
# *******
# 
# Software License Agreement
# 
# Permission is given to copy <name_of_program>, and its files (the Software)
# and to use them locally, as long as foregoing Copyright Notice is not
# removed and the Software name is retained unaltered.  By opening,
# possessing, retaining, using, or having a copy of  the Software, you
# are deemed to have agreed to the terms of this Software License
# Agreement.
# 
# The Software is provided strictly on an "as is" basis without warranty
# of any kind.   Neither the University of North Carolina at Chapel
# Hill, its faculty, staff or students, nor anyone else who has been
# involved in the creation, production or delivery of the Software
# shall be liable for any direct, indirect, consequential or incidental
# damages arising out of the use or inability to use the Software even
# if such entities or persons may be advised of the possibility of such
# damages.
# 
# No part of this software may be sold or distributed in any form or by
# any means without the prior written permission of the Department of
# Computer Science, University of North Carolina at Chapel Hill.  Your
# use of the Software is limited to non-commercial, not-for-profit uses
# and activities.  To secure permission to make any other use of the
# Software, you should contact the person named below.
# 
# 
# Contact person:
# 
# 	Frank D. Smith, University of North Carolina at Chapel Hill
# 	email: smithfd@cs.unc.edu
# 	phone: 919-962-1884
# 	fax:   919-962-1799
#----------------------------------------------------------------------

# Use this script to get the stats (mean/median/quartiles) of a single column
# of numbers supplied into stdin. Use this to collect CPU/memory stats from the
# .ts (tmix output) files.

my $usage=<<EOF;
Description:
	Given a list of numbers on stdin generate stats
	and optionally a cdf for the numbers.
Usage:
   $progname [options]
Options:
   -h      Show this help message.
   -c      Output cdf on stdout.
EOF

use strict;

#    Data tables are hash tables of frequencies, where the key is the 
# data point and the value is the frequency of the data point. The tables 
# also maintain a count of the total number of data points seen (under the 
# key "num".)

# -----------------------------------------------------------------------------
#
# ADD_DATA_POINT
#
# Input:        $data_point   to be added to the frequency table.
#
# Input/Output: $data_table   reference to a hash table of frequencies. 
#
# -----------------------------------------------------------------------------

sub add_data_point {

	my ( $data_point, $data_table ) = @_;

	$data_table->{$data_point}++;
	$data_table->{"num"}++;
}

# -----------------------------------------------------------------------------
#
# ADD_DATA_ARRAY
#
# Input:        $data_array_ptr   array of point to be added to 
#                                 the frequency table.
#
# Input/Output: $data_table   reference to a hash table of frequencies. 
#
# -----------------------------------------------------------------------------

sub add_data_array {

	my ( $data_array_ptr, $data_table ) = @_;
	my ($data_point);

	for $data_point (@$data_array_ptr) {
		$data_table->{$data_point}++;
		$data_table->{"num"}++;
	}
}

# -----------------------------------------------------------------------------
#
# BUILD_FREQBASED_CDF
#
# Input: $filename       where output is directed.
#        $data           reference to a hash table of frequencies 
#
# Output: (<filehandle>) CDF of the given data points, including an informative
#                        header (its lines are preceeded by #)
#
# -----------------------------------------------------------------------------

sub build_freqbased_cdf {

	my ( $filehandle, $data ) = @_;

	my ($num_points, $tot, $value, $key, $file, $prob);

	if ( exists $data->{"num"} ) {
		$num_points = $data->{"num"}; 
	} else {
		$num_points = 0;
	}

	delete $data->{"num"}; # avoiding conflict with numeric sort

	print $filehandle "# probability computed over the cumulative frequency of the values\n";
	if (scalar @ARGV) {
		print $filehandle "# script $0 processed the following files:\n";
		foreach $file (@ARGV) {
			print $filehandle "# $file\n";
		}
	} else {
		print $filehandle "# script $0 processed STDIN\n";
	}
	print $filehandle "# number of data points: $num_points\n";

	$tot = 0;

	foreach $key (sort numerically keys %$data) {

		$tot  += $data->{$key};
		$prob = $tot / $num_points;

		print $filehandle "$key $prob\n";
	}

	# preserve data table
	$data->{"num"} = $num_points;

}

# -----------------------------------------------------------------------------
#
# BUILD_WEIGHTBASED_CDF
#
# Input: $filename       where output is directed.
#        $data           reference to a hash table of frequencies 
#
# Output: (<filehandle>) CDF of the given data points, including an informative
#                        header (its lines are preceeded by #)
#
# -----------------------------------------------------------------------------

sub build_weightbased_cdf {

	my ( $filehandle, $data ) = @_;

	my ($num_points, $total_weight, $tot, $value, $key, $file, $prob);

	if ( exists $data->{"num"} ) {
		$num_points = $data->{"num"}; 
	} else {
		$num_points = 0;
	}

	delete $data->{"num"}; # avoiding conflict with numeric sort

	print $filehandle "# probability computed over the cumulative weight of the value\n"; 
	if (scalar @ARGV) {
		print $filehandle "# script $0 processed the following files:\n";
		foreach $file (@ARGV) {
			print $filehandle "# $file\n";
		}
	} else {
		print $filehandle "# script $0 processing STDIN\n";
	}
	print $filehandle "# number of data points: $num_points\n";

	$total_weight = 0;

	foreach $key (keys %$data) {
		$total_weight += $key * $data->{$key};
	}

	print $filehandle "# total value: $total_weight\n";

	if ($total_weight == 0) {
		print $filehandle "# no weighted cdf is possible\n";
	} else {

		$tot = 0;

		foreach $key (sort numerically keys %$data) {

			$tot  += $key * $data->{$key};
			$prob = $tot / $total_weight;

			print $filehandle "$key $prob\n";
		}
	}

	# preserve data table
	$data->{"num"} = $num_points;
}

sub numerically { $a <=> $b; }

use Getopt::Std;

my (%opts);
if (not getopts("hc", \%opts) or $opts{"h"} or @ARGV != 0) {
	print "$usage";
	exit;
}

my %cdf;
my (@values, $tot_value, $num_values, $tot_sq_value);
while(<STDIN>) {
	next if (/\#/);
	chomp;
	die "one number per line expected" if ($_ !~ /[\d\.eE+-]+/);

	push @values, $_;
	if($opts{"c"}){
		my $g = format_t($_);
		&add_data_point($g, \%cdf);
	}
	$num_values++;
	$tot_value += $_;
	$tot_sq_value += $_ * $_;
}

my @sorted = sort { $a <=> $b } @values;

print "# Mean: " . ($tot_value / $num_values) . "\n";
print "# Stdev: " . sqrt(($tot_sq_value - ($tot_value ** 2) / $num_values) 
	/ ($num_values - 1)) . "\n";

my $i = $#sorted / 2;
if (int($i) == $i) {
	print "# Median: " . $sorted[$i] . "\n";
} else {
	print "# Median: " . 
	(($sorted[@sorted / 2 - 1] + $sorted[@sorted / 2]) / 2) . "\n";
}

print "# Min: " . $sorted[0] . "\n";
print "# Max: " . $sorted[$#sorted] . "\n";

# First Quartile

my $pr = 0.25;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 1Q: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 1Q: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# Third Quartile

my $pr = 0.75;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 3Q: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 3Q: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# 5th Percentile

my $pr = 0.05;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 5th: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 5th: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# 95th Percentile

my $pr = 0.95;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 95th: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 95th: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# 2.5th Percentile

my $pr = 0.025;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 2.5th: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 2.5th: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# 97.5th Percentile

my $pr = 0.975;
$i = $#sorted * $pr;
my $iprev = int($i);
if ($iprev == $i) {
	print "# 97.5th: " . $sorted[$i] . "\n";
} else {
	my $prob_diff = 1 / $num_values;
	my $p = ($prob_diff - ($pr - $iprev / $num_values)) / $prob_diff;
	printf "# 97.5th: %s\n", $sorted[$iprev] * $p + $sorted[$iprev + 1] * (1- $p); 
}

# output the CDF
use IO::File;
if($opts{"c"}){
	my $fh = new IO::File ">-";
	&build_freqbased_cdf($fh, \%cdf);
	$fh->close;
}

sub format_t
{
	my ($t) = @_;

	if ($t < 1.0) {
		return sprintf("%.3f", $t);
	} elsif ($t < 10.0) {
		return sprintf("%.2f", $t);
	} elsif ($t < 100.0) {
		return sprintf("%.1f", $t);
	} else {
		return sprintf("%.0f", $t);
	}
}

