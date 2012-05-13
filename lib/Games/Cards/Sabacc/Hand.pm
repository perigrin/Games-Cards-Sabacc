package Games::Cards::Sabacc::Hand;
use Moose;

use List::Util qw(sum);

has cards => (
    isa     => 'ArrayRef',
    default => sub { [] },
    traits  => ['Array'],
    handles => {
        add_cards       => 'push',
        cards           => 'elements',
        number_of_cards => 'count',
        _has_card       => 'grep',
        first_index     => 'first_index',
        remove_card     => 'delete',
        get_card        => 'get',
        sort            => [ 'sort', sub { $a->value <=> $b->value } ],
    },
);

sub show {
    my $self = shift;
    return join ', ', map { $_->name } $self->cards;
}

sub value {
    my $self = shift;
    return sum map { $_->value } $self->cards;

}

sub has_idiots_array {
    my $self = shift;
    return 1
        if $self->_has_card( sub { $_->value == 0 } ) &&    # the idiot
            $self->_has_card( sub { $_->value == 2 } )
            &&                                              # a 2 of any suit
            $self->_has_card( sub { $_->value == 3 } );     # a 3 of any suit
    return 0;
}

sub pure_sabacc { 
        my $self = shift;
        abs($self->value) == 23;
}

sub bombed_out {
    my $self = shift;
    return 1 if abs( $self->value ) > 23;
}

__PACKAGE__->meta->make_immutable;
1;
__END__
