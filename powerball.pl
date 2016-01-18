#!/usr/bin/perl
use strict;
use warnings;
use List::Util qw(shuffle);

my @data = (1..69);

my @white_nums = shuffle @data;


sub pick_lotto_nums {
my $random_number_red = int(rand(25)) + 1;
my @lotto_nums = ();
for (my $i =1; $i <= 5; $i++) {
  my $chosen_white = pop @white_nums;
  push @lotto_nums, $chosen_white;
}
push @lotto_nums, $random_number_red;
print "@lotto_nums";
}

pick_lotto_nums;
