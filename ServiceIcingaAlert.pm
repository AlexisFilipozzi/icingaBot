# CLass pour définir un alerte de service de la part d'icinga
package ServiceIcingaAlert;
use IcingaAlert;

our @ISA = {"IcingaAlert"};

sub new {
        my ($class, $status, $host, $service, $message) = @_;
        my $self = $class->SUPER::new($status, $host, $message);
        $self->{service} = $service;

        bless($self, $class);
        return($self);
}
