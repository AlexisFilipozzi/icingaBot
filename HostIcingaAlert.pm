# classe pour définir une alerte d'hôte de la part d'icinga
package HostIcingaAlert;
use IcingaAlert;

our @ISA = ("IcingaAlert");
sub new {
        my ($class, $status, $host, $message) = @_;
        my $self = $class->SUPER::new($status, $host, $message);

        bless($self, $class);
        return($self);
}
