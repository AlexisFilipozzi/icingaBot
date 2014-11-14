#!/usr/bin/perl

use LWP::UserAgent;
use HTTP::Request::Common;
use Getopt::Std;

sub usage {
        print "USAGE send_irc_notification.pl -H hostname -M message [-p port]";
}

if (@ARGV <1) {
        usage();
        exit(2);
}

my $port = 9000;
my $hostname;
my $message;

getopts("H:M:p:");

if (defined($opt_H)) {
  $hostname = $opt_H;
} else {
  usage();
  exit(2);
}

if (defined($opt_p)) {
  $port = $opt_p;
}

if (defined($opt_M)) {
  $message = $opt_M;
} else {
  usage();
  exit(2);
}

my $url = "http://$hostname:$port/icingabot";

my $ua      = LWP::UserAgent->new();
my $request = POST( $url, [ 'message' => $message ] );
my $returnCode = $ua->request($request)->code;

if ($returnCode != 200) {
  exit(2);
}
exit(0);
