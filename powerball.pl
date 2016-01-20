#!/usr/bin/perl
use strict;
#use warnings;
use List::Util qw(shuffle);
use List::Compare;

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

sub check_winnings {
  my ($winning_ticket_ref, $checked_ticket_ref) = @_;
  my @winning_ticket = @{ $winning_ticket_ref };
  my @checked_ticket = @{ $checked_ticket_ref };
  my @winning_whites = @winning_ticket[0..4];
  my @lotto_whites = @checked_ticket[0..4];
  my $comp_whites = List::Compare->new(\@winning_whites, \@lotto_whites);
  my @intersection = $comp_whites->get_intersection();
  print "The intersection is @intersection\n";
  my $in_size = @intersection;
  if ($in_size == 5 && $winning_ticket[-1] == $checked_ticket[-1]) {
    print "You won the jackpot!!!\n";
    print "@winning_ticket and @checked_ticket\n";
    return 40000000;
  }
  elsif ($in_size == 5) {
      print "Hey you won a million dollars!!!\n";
      print "@winning_ticket and @checked_ticket\n";
      return 1000000;
    }
  elsif ($in_size && $winning_ticket[-1] == $checked_ticket[-1]) {
    print "Wow you won 50K!!!\n";
    #print "@winning_ticket and @checked_ticket\n";
    return 50000;
  }
  elsif ($in_size == 4) {
    return 100;
  }
  elsif ($in_size && $winning_ticket[-1] == $checked_ticket[-1]) {
    return 100;
  }
  elsif ($in_size == 3) {
    return 7;
  }
  elsif ($in_size == 2 && $winning_ticket[-1] == $checked_ticket[-1]) {
    return 7;
  }
  elsif ($winning_ticket[-1] == $checked_ticket[-1]) {
    print "YES\n";
    return 4;
  }
  else {
    return 0;
  }
}


sub play_lotto {
  my ($num_tickets) = @_;
  my @winning_nums = pick_lotto_nums;
  my $winnings = 0;
  for (my $i =1; $i <= $num_tickets; $i++){
    my @lotto_ticket = pick_lotto_nums;
    $winnings = $winnings + check_winnings(\@winning_nums, \@lotto_ticket);
  }
  print "You won $winnings dollars this drawing.\n";
  return $winnings;
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
  my $total_winnings = 0;
  for (my $i =1; $i <= $num_trials; $i++) {
    print "This is drawing #$i.\n";
    my $result = play_lotto($num_ticks);
    $total_winnings = $total_winnings + $result;
    if ($result >= 40000000) {
      my $jackpot_takehome = $total_winnings - $money;
      my $output =  "It took you $i draws to win the jackpot! You purchased $num_ticks tickets every draw.\n";
      print commify($output);
      my $output1 =  "You purchased $total_ticks tickets for a total of $money dollars. \n";
      print commify($output1);
      my $output6 = "After buying all those tickets your net result is $jackpot_takehome dollars.\n";
      print commify($output6);
      last;
    }
    elsif ($i == $num_trials){
      my $losses = $money - $total_winnings;
      my $output4 =  "You didn't win the jackpot in $num_trials draws. You spent $money dollars on $total_ticks tickets.\n";
      print commify($output4);
      my $output5 = "You won $total_winnings dollars. You lost $losses dollars playing the lottery.\n";
      print commify($output5);
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
