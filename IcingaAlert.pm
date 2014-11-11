# Classe qui définit une alerte Icinga 
# Cette classe est utilisé pour définir une alerte 
# d'hôte et une alerte de service

package IcingaAlert;
use warnings;
use strict;

sub new {
        my ($class, $status, $host, $message) = @_;
        $class = ref($class) || $class;
        my $self = {};
        $self->{status} = $status;
        $self->{host} = $host;
        $self->{message} = $message;

        bless($self, $class);
        return($self);
}


1;
