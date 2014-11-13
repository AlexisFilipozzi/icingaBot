#!/usr/bin/perl

use strict;
use warnings;

use IcingaBot;

# Configuration de la connexion (serveur, login, channel)
my $server = 'irc.viabile.via.ecp.fr';
my $nick = 'IcingaBot';
my $channel = '#icinga2';
my $ircname = 'IcingaBot';
my $username = 'IcingaBot';

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
