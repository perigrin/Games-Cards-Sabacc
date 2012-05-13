package Games::Cards::Sabacc::Table;
use Moose;
use namespace::alias 'Games::Cards::Sabacc::Deck';
use namespace::alias 'Games::Cards::Sabacc::Round';

has deck => (
    is      => 'ro',
    isa     => Deck,
    default => sub { Deck->new },
);

has main_pot => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
);

has sabacc_pot => (
    is      => 'ro',
    isa     => 'Int',
    default => 0,
);

has players => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    traits   => ['Hash'],
    handles  => { 'hand' => 'get', },
);

sub new_round {
    my ( $self, @players ) = @_;
    Round->new(
        table   => $self,
        hands => [ map { $self->hand($_) } @players ],
    );
}

__PACKAGE__->meta->make_immutable;
1;
__END__
