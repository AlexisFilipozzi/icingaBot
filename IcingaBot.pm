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

#Fichier utilisé pour transmettre des commandes au bot
my $inputFile = '/tmp/icingaBot';
my $fileSuffix = '.tmp';
my $copyFile = $inputFile.$fileSuffix;

# Nombre de seconde pour actualiser les alertes
my $refresh = 5;

my@icingaAlerts;

####################################
# Overriding Bot::BasicBot methods #
####################################

our @ISA = ("Bot::BasicBot");

sub new {
          my ($class, %table) = @_;
          my $self = $class->SUPER::new(%table);
        bless ($self, $class);
        return $self;
}

sub connected {
        my ($self) = @_;
        $self->say(
                channel=>$self->{channels}[0],
                body=>"IcingaBot, version: $version",
                );
}

sub tick {
        my ($self) = @_;
        $self->readInputFile();
        $self->displayAlerts();
        return $refresh; # This method will be re-executed in $refresh second
}

################
# Coeur du Bot #
################

sub readInputFile {
        my ($self) = @_;
        if (-e $inputFile) {
                move($inputFile, $copyFile) or die "Move failed!"; 
                open(FILE, '<:encoding(UTF-8)', $copyFile)
                 or die "Couldn't open file $copyFile !";

                while (my $line = <FILE>) {
                        push(@icingaAlerts, $line);
                }

                close FILE
                   or warn $! ? "Error closing sort pipe: $!"
                        : "Exit status $? from sort";
                unlink $copyFile;
        }
}

sub displayAlerts {
        my ($self) = @_;
        while(defined(my $alert=shift(@icingaAlerts))) {
                $self->say(
                        channel=>$self->{channels}[0],
                        body=>$alert,
                        );
        }
}

