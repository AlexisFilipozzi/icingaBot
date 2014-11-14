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
my $portIcinga = 9000;

my $bot = IcingaBot->new(
    server      => $server,
    port        => "6601",
    ssl         => 1,
    channels    => [$channel],
    nick        => $nick,
    alt_nicks   => ["Icinga<3"],
    username    => $ircname,
    name        => $username,
    portIcinga  => $portIcinga,
    allowed_ips => ['127.0.0.1',
                    '0.0.0.0',
                    '138.195.128.19', #Staross
                    '138.195.128.17', #Belzebuth
                    '2002:8ac3:802d:1243:5054:ff:feff:857f', #Belzebuth
                    '2002:8ac3:802d:1243:5054:ff:feff:93a0', #Staross
                   ],
);
while(1) {
  $bot->run();
}
