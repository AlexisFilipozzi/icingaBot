#!/usr/bin/perl
# Copyright © 2014 Alexis Filipozzi <ale@via.ecp.fr>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

use strict;
use warnings;

use IcingaAlert;
use HostIcingaAlert;
package IcingaBot;
use base qw( Bot::BasicBot );
use utf8;
use feature qw(switch);

##################
# Some variables #
##################

# Version
my $version = 0.1;

# Configuration de la connexion (serveur, login, channel)
my $server = 'irc.viabile.via.ecp.fr';
my $nick = 'Icinga';
my $channel = '#icinga2';
my $ircname = 'Icinga';
my $username = 'Icinga';

# Tableau utilisé pour stocker le contenu du fichier
my @icingaAlerts = ();

####################################
# Overriding Bot::BasicBot methods #
####################################

sub connected {
        my ($self) = @_;
        $self->say(
                channel=>$channel,
                body=>"IcingaBot, version: $verseion",
                );
}

sub tick {
        my ($self) = @_;
        $self->say(
                channel=>$channel,
                body=>"I'am still here !",
        );
        return 5*60;
}

#######################
# Launching IcingaBot #
#######################


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
