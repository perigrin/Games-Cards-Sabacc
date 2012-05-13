#!/usr/bin/env perl

use strict;
use Test::More;

use Games::Cards::Sabacc;

my $table = Games::Cards::Sabacc::Table->new();
my $deck  = $table->deck;
is $deck->count,       76, 'right number of cards';
is $table->main_pot,   0,  'main pot is empty';
is $table->sabacc_pot, 0,  'sabacc pot is empty';

done_testing;
