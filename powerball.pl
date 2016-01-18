#!/usr/bin/perl
use strict;
use warnings;

sub pick_lotto_nums {
my $random_number_red = int(rand(25)) + 1;
my @lotto_nums = ();
for (my $i =1; $i <= 5; $i++) {
  my $random_number_white = int(rand(68)) + 1;
  push @lotto_nums, $random_number_white;
}
push @lotto_nums, $random_number_red;
print "@lotto_nums";
}

pick_lotto_nums;
