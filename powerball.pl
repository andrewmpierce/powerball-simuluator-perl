#!/usr/bin/perl
use strict;
use warnings;
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


sub pick_multiplier {
  my @multiplier_poss = (2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,5,5);
  my @multiplier = shuffle @multiplier_poss;
  my $chosen_multiplier = pop @multiplier;
  return $chosen_multiplier;
}



sub check_winnings {
  my ($winning_ticket_ref, $checked_ticket_ref, $multiplier) = @_;
  my @winning_ticket = @{ $winning_ticket_ref };
  my @checked_ticket = @{ $checked_ticket_ref };
  my @winning_whites = @winning_ticket[0..4];
  my @lotto_whites = @checked_ticket[0..4];
  my $comp_whites = List::Compare->new(\@winning_whites, \@lotto_whites);
  my @intersection = $comp_whites->get_intersection();
  my $in_size = @intersection;
  if ($in_size == 5 && $winning_ticket[-1] == $checked_ticket[-1]) {
    print "You won the jackpot!!!\n";
    print "@winning_ticket and @checked_ticket\n";
    return 40000000;
  }
  elsif ($in_size == 5) {
      print "Hey you won a million dollars!!!\n";
      print "@winning_ticket and @checked_ticket\n";
      if ($multiplier != 1) {
      return 2000000;
      }
      else {
        return 1000000;
      }
    }
  elsif ($in_size == 4 && $winning_ticket[-1] == $checked_ticket[-1]) {
    print "Wow you won 50K!!!\n";
    return 50000 * $multiplier;
  }
  elsif ($in_size == 4) {
    return 100 * $multiplier;
  }
  elsif ($in_size && $winning_ticket[-1] == $checked_ticket[-1]) {
    return 100 * $multiplier;
  }
  elsif ($in_size == 3) {
    return 7 * $multiplier;
  }
  elsif ($in_size == 2 && $winning_ticket[-1] == $checked_ticket[-1]) {
    return 7 * $multiplier;
  }
  elsif ($winning_ticket[-1] == $checked_ticket[-1]) {
    return 4 * $multiplier;
  }
  else {
    return 0;
  }
}


sub play_lotto {
  my ($num_tickets, $mult) = @_;
  my @winning_nums = pick_lotto_nums;
  my $multiplier = 1;
  if ($mult eq "yes") {
   $multiplier = pick_multiplier;
  }
  my $winnings = 0;
  for (my $i =1; $i <= $num_tickets; $i++){
    my @lotto_ticket = pick_lotto_nums;
    $winnings = $winnings + check_winnings(\@winning_nums, \@lotto_ticket, $multiplier);
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
  my ($num_trials, $num_ticks, $powerplay) = @_;
  my $total_ticks = $num_trials * $num_ticks;
  my $money = $total_ticks * 2;
  if ($powerplay eq "yes") {
    $money = $total_ticks * 3;
  }
  my $total_winnings = 0;
  for (my $i =1; $i <= $num_trials; $i++) {
    print "This is drawing #$i.\n";
    my $result = play_lotto($num_ticks, $powerplay);
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
      my $final_money = $total_winnings - $money;
      my $output4 =  "You didn't win the jackpot in $num_trials draws. You spent $money dollars on $total_ticks tickets.\n";
      print commify($output4);
      if ($final_money <= 0){
        $final_money = $final_money * -1;
      my $output5 = "You won $total_winnings dollars. You lost $final_money dollars playing the lottery.\n";
      print commify($output5);
    }
      else {
        my $output5 = "You won $total_winnings dollars. You netted $final_money dollars playing the lottery.\n";
        print commify($output5);
      }
    }
  }
}


sub run_sim {
  print "Let's play the lottery!\n";
  print "How many tickets do you want to buy per drawing?\n";
  my $num_ticks = <STDIN>;
  print "How many drawings do you want to play for?\n";
  my $num_drawings = <STDIN>;
  print "Do you want to purchase the powerplay for an extra \$1 per ticket? yes/no\n";
  my $powerplay = <STDIN>;
  chomp($powerplay);
  run_trials($num_drawings, $num_ticks, $powerplay);
}

run_sim;
