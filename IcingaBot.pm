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
use Switch;
use Term::ANSIColor qw(:constants);
use AnyEvent::HTTPD;
use threads;
use Config;

# IcingaBot a besoin des threads pour lancer un serveur HTTP
$Config{useithreads} or die
      "Recompilez Perl avec les threads activés pour faire tourner ce programme.";

##################
# Some variables #
##################

# Version
my $version = 0.1;

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
        $self->{httpd} = AnyEvent::HTTPD->new(
                port => $table{portIcinga}||9000,
                host => '0.0.0.0',
                request_timeout => 30,
                allowed_methods => ['GET', 'POST'],
        );
        $self->{httpd}->reg_cb (
                '/icingabot'=> sub {
                        my ($httpd, $req) = @_;
                        my %vars = $req->vars;
                        unless($req->method eq 'POST' && defined($vars{message}) && $self->check_client($req)) {
                                $req->respond([400, 'bad request', {}, '']);
                        } else {
                                push(@icingaAlerts, $vars{message});
                        }
                        $req->respond([200, 'ok', {'Content-Type' => 'text/html'}, 'Message added to the queue']);
                        $httpd->stop_request;
                }
        );
        $self->{allowed_ips} = $table{allowed_ips};
        bless ($self, $class);
        return $self;
}

sub check_client {
        my ($self, $req) = @_;
        unless ($req->client_host ~~ $self->{allowed_ips}) {
                $req->respond([403, 'Forbidden', {}, '']);
                $self->{httpd}->stop_request;
                return 0;
        }
        return 1;
}

sub connected {
        my ($self) = @_;
        threads->create('startHTTP', $self);
        $self->say(
                channel=>$self->{channels}[0],
                body=>"IcingaBot, version: $version",
                );
}

sub tick {
        my ($self) = @_;
        $self->displayAlerts();
        return $refresh; # This method will be re-executed in $refresh second
}

sub startHTTP {
        my ($self) = @_;
        $self->{httpd}->run();
}

################
# Coeur du Bot #
################

sub displayAlerts {
        my ($self) = @_;
        while(defined(my $alert=shift(@icingaAlerts))) {
                $self->say(
                        channel=>$self->{channels}[0],
                        body=>$self->colorize($alert),
                        );
        }
}

sub colorize {
        my ($self, $message) = @_;
        my @words = split / /, $message;
        my $color = "";
        my $defaultColor = RESET;
        my$state = "";
        #Notification Type
        my $notificationType = shift @words;
        switch ($notificationType) {
                case "PROBLEM:"                 {$color = RED}
                case "RECOVERY:"                {$color = GREEN}
                case "ACKNOWLEDGEMENT:"         {$color = BLUE}
                case "FLAPPINGSTART:"           {$color = YELLOW}
                case "FLAPPINGSTOP:"            {$color = MAGENTA}
                case "FLAPPINGEND:"             {$color = CYAN}
                case "DOWNTIMESTART:"           {$color = CYAN}
                case "DOWNTIMEEND:"             {$color = BLUE}
                case "DOWNTIMECANCELLED:"       {$color = BLUE}
                else                            {$color = RESET}
        }
        $message = $color.$notificationType.$defaultColor.' ';
        while (@words && $#words != 0) {
                $message = $message.(shift @words).' ';
        }        
        #Host/Service State
        $state = shift @words || '';
        $state =~ s/\n//g;
        switch ($state) {
                case "OK"       {$color = GREEN}     
                case "WARNING"  {$color = YELLOW}
                case "CRITICAL" {$color = RED}
                case "UNKNOWN"  {$color = MAGENTA}
                case "UP"       {$color = GREEN}
                case "DOWN"     {$color = RED}
                else              {$color = RESET}
        }
        $message = $message.$color.$state;
        return $message;
}
