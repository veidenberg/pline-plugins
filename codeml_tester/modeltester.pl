#!/usr/bin/perl
#collects CodeML results to csv table. Input: CodeML .mlc file(s).
#Andres Veidenberg (2019)

use strict;
use warnings;
if(!$ARGV){ die "Usage: $0 sitemodels.mlc [branchmodel.mlc] [outfile.csv] [-sites] [-branches]\n"; }
my %arg = map{$_ => 1} @ARGV;
#open files
my $smlc = $ARGV[0];
open(my $in, '<', $smlc) or die "Can't open input file $smlc: $!\n";
my $bmlc = $ARGV[1] and $ARGV[1]=~/^\w+\.mlc$/? $ARGV[1] : '';
if($bmlc){ open(my $in2, '<', $bmlc) or die "Can't open input file $bmlc: $!\n"; }
elsif($arg{'-branches'}){ print "Can't write branch values: branch model .mlc file not given!\n"; }
my $outfile = $ARGV[2] and $ARGV[2]=~/^\w+\.\w+$/? $ARGV[2] : "model_tests.csv";
open(my $out, ">", $statfile) or die "Can't write output file $outfile: $!\n";

#header row
my @header = ("Omega", "M1 vs M2", "M7 vs M8");
if($arg{'-sites'}){ push(@header, "Pos. sites"); }
if($bmlc){
	push(@header, "M0 vs bM2");
	if($arg{'-branches'}) push(@header, "Pos. branches");
}
print $out join("\t", @header);
print $out "\n";
my @cols = map("NA", @header);

#parse site models .mlc file
my $model = 0;
my @lnl;
my $beb;
my @psites;
while(<$in>){
	if(/^Model (\d):/){ $model = $1; $beb = 0; } #current model
	elsif(/\(BEB\) analysis/){ $beb = 1; } #BEB section reached
	elsif(/^lnL.+:\s+([+-]\d+\.\d\d)/){ $lnl[$model] = $1; } #log-likelihood for each model
	elsif(!$model && /^omega.+=\s+(\S+)/){ $cols[0] = $1; } #omega from M0 model
	elsif($beb && /^\s+(\d+)\s+\w\s+\d\.\d+(\*+)/){ if($2) push(@psites, $1.$2); } #BEB results (siteNr+*/**)
}
close $in;
if($arg{'-sites'}){ $cols[3] = join(', ', @psites); }
#branch model .mlc
my $lnlb;
my @pbranches;
if($bmlc){
	while(<$in2>){
		if(/^lnL.+:\s+([+-]\d+\.\d\d)/){ $lnlb = $1; }
		elsif(/(\w+)? #(\d\.\d+)/){ push(@pbranches, ($1?$1.':':'').$2); }
	}
	if($arg{'-branches'}) $cols[$#cols] = join(', ', @pbranches);
}
close $in2;

#Likelihood ratio tests: M1a vs. M2a, M7 vs. M8, M0 vs. bM2(3 branch groups) (DF=2)
my $lr;
if($lnl[1] && $lnl[2]){
	$lr = 2*($lnl[2]-$lnl[1]);
	$cols[1] = $lr.($lr>5.99?'*':'').($lr>9.21?'*':''); #LRT** (95%/99% p-val)
} else { print "Model M1/M2 missing!\n"; }
if($lnl[7] && $lnl[8]){
	$lr = 2*($lnl[8]-$lnl[7]);
	$cols[2] = $lr.($lr>5.99?'*':'').($lr>9.21?'*':''); 
} else { print "Model M7/M8 missing!\n"; }
if($lnl[0] && $lnlb){
	$lr = 2*($lnlb-$lnl[0]);
	$cols[$arg{'-sites'}?4:3] = $lr.($lr>5.99?'*':'').($lr>9.21?'*':''); 
} else { print "Model M0/branch model missing!\n"; }

#write output
print $out join("\t", @cols);
print $out "\n";
close $out;
print "Output written to $out\n";