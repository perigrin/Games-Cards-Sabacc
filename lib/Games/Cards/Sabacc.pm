{

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
}

{

    package Games::Cards::Sabacc::Deck;
    use Moose;
    use namespace::alias 'Games::Cards::Sabacc::Card';

    has suits => (
        isa     => 'ArrayRef',
        traits  => ['Array'],
        handles => { suits => 'elements' },
        lazy    => 1,
        default => sub { [qw(Coins Flasks Sabres Staves)] },
    );

    has face_cards => (
        is      => 'ro',
        isa     => 'HashRef',
        traits  => ['Hash'],
        handles => { list_face_cards => 'kv' },
        lazy    => 1,
        builder => "default_face_cards"
    );

    sub default_face_cards {
        {   'Queen of Air and Darkness' => -2,
            'Endurance'                 => -8,
            'Balance'                   => -11,
            'Demise'                    => -13,
            'Moderation'                => -14,
            'The Evil One'              => -15,
            'The Star'                  => -17,
            'The Idiot'                 => 0,
        };
    }

    has cards => (
        is      => 'ro',
        isa     => 'ArrayRef',
        traits  => ['Array'],
        handles => {
            deal  => 'pop',
            count => 'count'
        },
        lazy    => 1,
        builder => '_build_deck',
    );

    sub _build_deck {    # assume a standard deck
        my $self = shift;
        my @deck = ();
        for my $suit ( $self->suits ) {
            for my $value ( 1 .. 11 ) {
                push @deck, Card->new( suit => $suit, value => $value );
            }
            push @deck,
                Card->new( name => "Commander of $suit", value => 12 );
            push @deck, Card->new( name => "Mistress of $suit", value => 13 );
            push @deck, Card->new( name => "Master of $suit",   value => 14 );
            push @deck, Card->new( name => "Ace of $suit",      value => 15 );
        }
        for my $kv ( $self->list_face_cards ) {
            my ( $paint, $value ) = @$kv;
            push @deck, Card->new( name => $paint, value => $value );
            push @deck, Card->new( name => $paint, value => $value );
        }
        return \@deck;
    }
    __PACKAGE__->meta->make_immutable;
}

{

    package Games::Cards::Sabacc::Table;
    use Moose;
    use namespace::alias 'Games::Cards::Sabacc::Deck';

    has deck => (
        is      => 'ro',
        isa     => Deck,
        default => sub { Deck->new },
    );

    has main_pot => (
        is  => 'ro',
        isa => 'Int',
        default => 0,
    );

    has sabacc_pot => (
        is  => 'ro',
        isa => 'Int',
        default => 0,
    );

    __PACKAGE__->meta->make_immutable;
}

{

    package Games::Cards::Sabacc;
    use strict;

    # ABSTRACT: Classes for Creating Sabacc Games

}
1;
__END__
