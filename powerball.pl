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
  my @winning_whites = @winning_nums[0..4];
  print "@winning_whites\n";
  for (my $i =1; $i <= $num_tickets; $i++){
    my @lotto_ticket = pick_lotto_nums;
    my @lotto_whites = @lotto_ticket[0..4];
    my $comp = Array::Compare->new;
    my $comp_whites = Array::Compare->new;
    if ($comp->compare(\@winning_nums, \@lotto_ticket)) {
      print "You won the jackpot!!!\n";
      print "@winning_nums and @lotto_ticket\n";
      last;
      return "jackpot";
    }
    elsif ($comp_whites->compare(\@winning_whites, \@lotto_whites)) {
        print "Hey you won a million dollars!!!";
        print "@winning_nums and @lotto_ticket";
        last;
        return "million";
      }
    else {
      print "@lotto_ticket doesn't match @winning_nums.\n";
    }
  }
}

sub run_sim {
  my ($num_trials, $num_ticks) = @_;
  for (my $i =1; $i <= $num_trials; $i++) {
    my $result = play_lotto($num_ticks)
    if ($result eq "jackpot") {
      print "It took you $i draws to win the jackpot, you purchased $num_ticks every draw\n";
      }
    elsif ($result eq "million") {
      print "It took you $i draws to win a million dollars, you purchased $num_ticks every draw\n";
    }
  }
}

run_sim(100, 200)
