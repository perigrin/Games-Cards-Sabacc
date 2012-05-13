package Games::Cards::Sabacc::Card;
use Moose;

has suit => (
    is  => 'ro',
    isa => 'Str',
);

has value => (
    is  => 'ro',
    isa => 'Int',
);

has name => (
    is      => 'ro',
    isa     => 'Str',
    lazy    => 1,
    default => sub { $_[0]->value . ' of ' . $_[0]->suit },
);
__PACKAGE__->meta->make_immutable;
1;
__END__