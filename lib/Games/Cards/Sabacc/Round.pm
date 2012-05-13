package Games::Cards::Sabacc::Round;
use Moose;
use namespace::alias 'Games::Cards::Sabacc::Table';
use List::MoreUtils qw(part);
has hands => (
    isa      => 'ArrayRef',
    required => 1,
    traits   => ['Array'],
    handles  => { hands => 'elements' },
);

has table => (
    is       => 'ro',
    isa      => Table,
    required => 1,
    handles  => [qw(deck)],
);

sub deal {
    my $self = shift;
    my $deck = $self->deck;
    for my $hand ( $self->hands ) {
        $hand->add_cards( $deck->get_cards(2) );
    }
    return $self;
}

sub draw {
    my ( $self, $hand ) = @_;
    my $deck = $self->deck;
    $hand->add_cards( $deck->get_cards(1) );
    return $self;
}

sub trade {
    my ( $self, $hand, $card ) = @_;
    my $deck = $self->deck;
    my $index = $hand->first_index( sub { $_ eq $card } );
    die "Card '${\$card->name}' not found in hand '${ \$hand->show }'"
        unless defined $index;
    $hand->remove_card($index);
    $hand->add_cards( $deck->get_cards(1) );
    return $self;
}

sub winner {
    my $self = shift;

    if ( my @idiots_array = grep { $_->has_idiots_array } $self->hands ) {
        if ( @idiots_array > 1 ) {
            return $self->sudden_demise(@idiots_array);
        }
        return shift @idiots_array;
    }

    if ( my @pure_sabacc = grep { $_->pure_sabacc } $self->hands ) {
        return shift @pure_sabacc if @pure_sabacc == 1;

        my ( $pos, $neg ) = part { $_->value < 0 } @pure_sabacc;

        return $self->sudden_demise(@$pos) if ( @$pos > 1 );
        return shift @$pos if ( @$pos > 0 );

        return $self->sudden_demise(@$neg) if ( @$neg > 1 );
        return shift @$neg if ( @$neg > 0 );
    }

    return unless grep { !$_->bombed_out } $self->hands;

    my @left = sort { abs( $b->value ) <=> abs( $a->value ) || $b->value <=> $a->value }
        grep { !$_->bombed_out } $self->hands;

    my @matches = grep { $_->value == $left[0]->value } @left;
    return shift @matches if @matches == 1;
    return $self->sudden_demise(@matches);
}

sub sudden_demise {
    my ( $self, @hands ) = @_;
    $self->draw($_) for @hands;
    return $self->winner();
}

__PACKAGE__->meta->make_immutable;
1;
__END__
