#!/usr/bin/perl
# Copyright © 2014 Alexis Filipozzi <ale@via.ecp.fr>
# This work is free. You can redistribute it and/or modify it under the
# terms of the Do What The Fuck You Want To Public License, Version 2,
# as published by Sam Hocevar. See the COPYING file for more details.

use strict;
use warnings;

package IcingaBot;
use base qw( Bot::BasicBot );
use utf8;
use feature qw(switch);
use File::Copy;

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

#Fichier utilisé pour transmettre des commandes au bot
my $inputFile = '/tmp/icingaBot';
my $fileSuffix = '.tmp';
my $copyFile = $inputFile.$fileSuffix;

####################################
# Overriding Bot::BasicBot methods #
####################################

sub connected {
        my ($self) = @_;
        $self->say(
                channel=>$channel,
                body=>"IcingaBot, version: $version",
                );
}

sub tick {
        my ($self) = @_;
        readInputFile($self);
        return 5; # This method will be re-executed in 5 second
}

################
# Coeur du Bot #
################

sub readInputFile {
        my ($bot) = @_;
        if (-e $inputFile) {
                move($inputFile, $copyFile) or die "Move failed!"; 
                open(FILE, '<:encoding(UTF-8)', $copyFile)
                 or die "Couldn't open file $copyFile !";

                while (my $line = <FILE>) {
                        $bot->say(
                                channel=>$channel,
                                body=>$line,
                                );
                }

                close FILE
                   or warn $! ? "Error closing sort pipe: $!"
                        : "Exit status $? from sort";
                unlink $copyFile;
        } else {
                print "Fichier $inputFile introuvable";        
        }
}

#########################
# Lancement d'IcingaBot #
#########################


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

