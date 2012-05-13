#!/usr/bin/env perl
use strict;
use Test::More;

use namespace::alias 'Games::Cards::Sabacc::Round';
use namespace::alias 'Games::Cards::Sabacc::Hand';
use namespace::alias 'Games::Cards::Sabacc::Card';
use namespace::alias 'Games::Cards::Sabacc::Table';

my $positive = Hand->new(
    cards => [
        Card->new( suit => 'Coins',  value => 5 ),
        Card->new( suit => 'Staves', value => 10 ),
    ]
);

my $negative = Hand->new(
    cards => [
        Card->new( name => 'The Idiot',    value => 0 ),
        Card->new( name => 'The Evil One', value => -15 ),
    ]
);

my $idiots_array = Hand->new(
    cards => [
        Card->new( name => 'The Idiot', value => 0 ),
        Card->new( suit => 'Coins',     value => 2 ),
        Card->new( suit => 'Coins',     value => 3 ),
    ]
);

my $pos_sabacc = Hand->new(
    cards => [
        Card->new( suit => 'Coins',  value => 11 ),
        Card->new( suit => 'Staves', value => 11 ),
        Card->new( suit => 'Coins',  value => 1 ),
    ]
);

my $neg_sabacc = Hand->new(
    cards => [
        Card->new( name => 'The Evil One', value => -15 ),
        Card->new( name => 'Endurance',    value => -8 ),
    ]
);

diag "Positive Hand: $positive";
diag "Negative Hand: $negative";
diag "Idiots Array: $idiots_array";
diag "Positive Sabacc: $pos_sabacc";
diag "Negative Sabacc: $neg_sabacc";

{
    my $round = Round->new(
        hands =>
            [ $idiots_array, $pos_sabacc, $neg_sabacc, $positive, $negative ],
        table => Table->new( players => {} )
    );
    is $round->winner, $idiots_array, 'Idiots Array beats all';
}
{
    my $round = Round->new(
        hands => [ $pos_sabacc, $neg_sabacc, $positive, $negative ],
        table => Table->new( players => {} )
    );
    is $round->winner, $pos_sabacc,
        '23 beats -23, 15, -15';
}

{
    my $round = Round->new(
        hands => [ $neg_sabacc, $positive, $negative ],
        table => Table->new( players => {} )
    );
    is $round->winner, $neg_sabacc,
        '-23 beats 15/-15 ';
}

{
    my $round = Round->new(
        hands => [ $positive, $negative, ],
        table => Table->new( players => {} )
    );
    is $round->winner, $positive, '15 beats -15';
}

{
    my $positive = Hand->new(
        cards => [
            Card->new( suit => 'Coins',  value => 4 ),
            Card->new( suit => 'Staves', value => 10 ),
        ]
    );
    my $round = Round->new(
        hands => [ $positive, $negative, ],
        table => Table->new( players => {} )
    );
    is $round->winner, $negative, '-15 beats 14';
}
{my $negative = Hand->new(
    cards => [
        Card->new( name => 'The Idiot',    value => 0 ),
        Card->new( name => 'Moderation', value => -14 ),
    ]
);
 
    my $round = Round->new(
        hands => [ $positive, $negative, ],
        table => Table->new( players => {} )
    );
    is $round->winner, $positive, '15 beats -14';
}

done_testing;
