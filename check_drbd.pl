#!/usr/bin/perl

use strict;
use Data::Dumper;

my $cmd = 'sudo /usr/sbin/drbd-overview';

my $output = `$cmd`;

my @connected;
my @nconnected;
my @state_pp;
my @state_un;

my $count = 0;
for my $line (split(/\n/, $output)) {
	$line =~ s/^\s+//;
	$line =~ s/^\d{1}://;
	my @rstate = split(/\s+/, $line);


	#haweb    Connected Primary/Primary UpToDate/UpToDate C r---- /var/www       ocfs2 10G  3.8G 6.3G 38%
	if ($rstate[1] eq "Connected") {
		push @connected, $rstate[0];
	} else {
		push @nconnected, $rstate[0];
	}

	if ($rstate[2] eq "Primary/Primary") {
		push @state_pp, $rstate[0];
	} else {
		push @state_un, $rstate[0] . " status: " . $rstate[2];
	}
	$count++;

}

if ($#connected == $count -1  && $#state_pp == $count - 1 ) {
	print "OK: All DRBD resources connected and primaried.\n";
	exit 0;
} else {
	print "WARNING: All DRBD resources NOT ok. " . join(', ', @state_un) . "\n";
	exit 1;
}

