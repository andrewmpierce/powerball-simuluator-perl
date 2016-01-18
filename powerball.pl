#!/usr/bin/perl
use strict;
use warnings;
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
      return "jackpot";
      last;
    }
    elsif ($comp_whites->compare(\@winning_whites, \@lotto_whites)) {
        print "Hey you won a million dollars!!!\n";
        print "@winning_nums and @lotto_ticket\n";
        return "million";
        last;
      }
    else {
      #print "@lotto_ticket doesn't match @winning_nums.\n";
    }
  }
}


sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}


sub run_trials {
  my ($num_trials, $num_ticks) = @_;
  my $total_ticks = $num_trials * $num_ticks;
  my $money = $total_ticks * 2;
  for (my $i =1; $i <= $num_trials; $i++) {
    print "This is drawing #$i.\n";
    my $result = play_lotto($num_ticks);
    if ($result eq "jackpot") {
      my $output =  "It took you $i draws to win! You purchased $num_ticks tickets every draw.\n";
      print commify($output);
      my $output1 =  "You purchased $total_ticks tickets for a total of $money dollars. \n";
      print commify($output1);
      last;
    }
    elsif ($result eq "million") {
      my $output2 =  "It took you $i draws to win! You purchased $num_ticks tickets every draw.\n";
      print commify($output2);
      my $output3 =  "You purchased $total_ticks tickets for a total of $money dollars. \n";
      print commify($output3);
      last;
    }
    elsif ($i == $num_trials){
      my $output4 =  "You didn't win in $num_trials draws. You spent $money dollars on $total_ticks tickets.\n";
      print commify($output4);
    }
  }
}


sub run_sim {
  print "Let's play the lottery!\n";
  print "How many tickets do you want to buy per drawing?\n";
  my $num_ticks = <STDIN>;
  print "How many drawings do you want to play for?\n";
  my $num_drawings = <STDIN>;
  run_trials($num_drawings, $num_ticks);
}

run_sim;
