#!/usr/bin/perl
#use strict;
#use warnings;
use List::Util qw(shuffle);
use Array::Compare;


sub pick_lotto_nums {
my @data = (1..69);
my @white_nums = shuffle @data;
my $random_number_red = int(rand(25)) + 1;
my @lotto_nums = ();
for (my $i =1; $i <= 5; $i++) {
  my $chosen_white = pop @white_nums;
  push @lotto_nums, $chosen_white;
}
my @sorted_nums = sort { $a <=> $b } @lotto_nums;
push @sorted_nums, $random_number_red;
return @sorted_nums;
}

sub play_lotto {
  my ($num_tickets) = @_;
  my @winning_nums = pick_lotto_nums;
  for (my $i =1; $i <= $num_tickets; $i++){
    my @lotto_ticket = pick_lotto_nums;
    my $comp = Array::Compare->new;
    if ($comp->compare(\@winning_nums, \@lotto_ticket)) {
      print "You won the jackpot!!!\n";
      print "@winning_nums and @lotto_ticket\n";
      last;
      }
    else {
      print "@lotto_ticket doesn't match @winning_nums.\n";
    }
  }
}

play_lotto(2000)
