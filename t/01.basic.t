#!/usr/bin/env perl
$|++;
use strict;
use Test::More;

use Games::Cards::Sabacc;
use namespace::alias 'Games::Cards::Sabacc::Table';
use namespace::alias 'Games::Cards::Sabacc::Hand';

ok my $table = Table->new(
    players => {
        'Han'   => Hand->new(),
        'Lando' => Hand->new()
    }
), 'new table';

is $table->deck->number_of_cards, 76, 'right number of cards';
is $table->main_pot,   0, 'main pot is empty';
is $table->sabacc_pot, 0, 'sabacc pot is empty';

# Ante (Start a new Round)

ok my $round = $table->new_round( 'Han', 'Lando' ), 'new round';

# Two cards dealt to each player

my $han = $table->hand('Han');
my $lando = $table->hand('Lando');

ok $round->deal(), 'deal first two cards';

is $han->number_of_cards, 2, 'Han has two cards';
is $lando->number_of_cards, 2, 'Lando has two cards';


# Hand totals declared

ok defined $han->value, 'Han has a hand worth '. $han->value;
ok defined $lando->value, 'Lando has a hand worth '. $lando->value;

diag "Han (${\$han->value}): ${ \$han->show }" ;
diag "Lando (${\$lando->value}): ${ \$lando->show }" ;

# Play Round

ok $round->draw($han), 'han draws';
ok $round->draw($lando), 'lando draws';

diag "Han (${\$han->value}): ${ \$han->show }" ;
diag "Lando (${\$lando->value}): ${ \$lando->show }" ;

ok $round->trade($han, $han->get_card(0)), 'han trades';
ok $round->trade($lando, $lando->get_card(0)), 'lando trades';

diag "Han (${\$han->value}): ${ \$han->show }" ;
diag "Lando (${\$lando->value}): ${ \$lando->show }" ;

# Betting Round

# Hand is Called during any Betting Round after the third.


my $winner = $round->winner;

if (defined $winner) {
        pass("we have a winner!");
        diag (($winner == $han ? 'Han' : 'Lando' ) . ' wins with ' . $winner->show);
} else {
        fail('Something is wrong, Han could have won') unless $han->bombed_out;
        fail('Something is wrong, Lando could have won') unless $lando->bombed_out;
        pass('Everyone bombed out') if $han->bombed_out && $lando->bombed_out;
}

done_testing;
