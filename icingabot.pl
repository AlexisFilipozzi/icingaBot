#!/usr/bin/perl

use strict;
use warnings;

use IcingaBot;

# Configuration de la connexion (serveur, login, channel)
my $server = 'irc.viabile.via.ecp.fr';
my $nick = 'Icinga';
my $channel = '#icinga2-test';
my $ircname = 'Icinga';
my $username = 'Icinga';

my $bot = IcingaBot->new(
    server    => $server,
    port      => "6601",
    ssl       => 1,
    channels  => [$channel],
    nick      => $nick,
    alt_nicks => ["Icinga<3"],
    username  => $ircname,
    name      => $username,
);

$bot->run();
