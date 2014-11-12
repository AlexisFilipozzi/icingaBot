#!/usr/bin/perl

use Getopt::Std;

my $file = "/tmp/icingaBot";
my $message = "";

sub usage {
        print "USAGE: sendNotification.pl -M message\n";
}

getopts("h:M:");

if (defined($opt_h)) {
        usage();
        exit(0);
        }

if (defined($opt_M)) {
        $message = $opt_M;
} else {
        usage();
        exit(2);
}


open (my $fh, '>>', $file) or die "Could not open file $file";
print $fh "$message\n";
close $fh;
1;

