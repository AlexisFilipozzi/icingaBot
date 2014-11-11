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
my $VERSION = 0.1;

# Configuration de la connexion (serveur, login, channel)
my $SERVER = 'irc.viabile.ecp.fr';
my $NICK = 'IcingaBot';
my $CHANNEL = '#icinga2';

# Tableau utilisé pour stocker le contenu du fichier
my @icingaAlerts = ();

