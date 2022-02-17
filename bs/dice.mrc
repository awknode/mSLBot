menu channel {
  Craps (Street Dice)
  .Street Dice On:/set %dice on | set %game.start no | set %point.set no | set %betting no | /msg $chan 5,8Street Dice is up and ready to roll. Type !dice to start. 
  .Street Dice Off:/set %dice off | /rlevel dice.able | unset %point.set | unset %point | unset %money | unset %game.start | unset %betting | unset %bet | unset %1roll | unset %2roll | unset %rolls | /msg $chan 5,8Street Dice is now off. Tables are closed. 
}
on dice.able:TEXT:!quit:#:/msg $chan 5,8 $+ 1 $+ $nick 5has quit IRC craps! | /rlevel dice.able | unset %point.set | unset %point | unset %money | unset %game.start | unset %betting | unset %bet | unset %1roll | unset %2roll | unset %rolls | set %game.start no | set %point.set no | set %betting no  
on *:TEXT:!dice:#: {
  if (%dice == off || %game.start == yes) { /halt }
  elseif (%dice == on && %game.start == no) {
  /auser -a dice.able $nick | set %game.start yes | set %money 500 | /msg $chan 5,8Welcome to IRC craps (dice). To get the game started, type !bet <amount to bet>. | /msg $chan 5,8Current money: 1$ $+ 5005. | /notice $nick If you do not know how to play craps, A.K.A. street dice, type !rules for help. | /notice $nick Type !quit at any time to quit the game. }
}
on dice.able:TEXT:!bet*:#: {
  if (%betting == yes) { /msg $chan 5,8You've already placed a bet. }
  elseif ($2 isnum && $2 <= %money && %betting == no) { 
  set %bet $round($2,0) | set %betting yes | set %money $calc(%money - %bet) | /msg $chan 5,8 $+ 1 $+ $nick 5throws down 1$ $+ %bet $+ 5. | /msg $chan 5,8Type !roll to start your round. }
  else { /msg $chan 5,8Either you didn't enter in a number, or you don't have that much money 1 $+ $nick $+ 5. Try again. }
}
on dice.able:TEXT:!roll:#: {
  if (%dice.timer == on) { /notice $nick Wait at least 5 seconds between each roll. | /halt }
  set %dice.timer on | /timer 1 3 /set %dice.timer off
  if (%betting == yes && %point.set == no) {
    set %1roll $rand(1,6) | set %2roll $rand(1,6) | set %rolls $calc(%1roll + %2roll)
    /msg $chan 5,8 $+ 1 $+ $nick 5rolled a1 %1roll 5,8and a1 %2roll 5,8for a total of1 %rolls $+ 5.
    if (%rolls == 7 || %rolls == 11) { set %money $calc(%bet * 2 + %money) | set %betting no | /msg $chan 5,8 $+ 1 $+ $nick 5wins on the come-out roll! | /msg $chan 5,8 $+ 1 $+ $nick 5has won 1$ $+ %bet $+ , 5for a total of 1$ $+ %money $+ 5. | /halt }
    if (%rolls == 2 || %rolls == 3 || %rolls == 12) { set %betting no | /msg $chan 5,8What a crappy roll (no pun intended). 1 $+ $nick 5loses on the come-out roll. | /msg $chan 5,8 $+ 1 $+ $nick 5has lost 1$ $+ %bet $+ , 5for a total of 1$ $+ %money $+ 5. | /halt }  
    else { set %point %rolls | set %point.set yes | /msg $chan 5,8Point set to1 %point $+ 5. | /halt }  
  }  
  if (%betting == no) { /msg $chan 5,8You have not yet placed a bet, 1 $+ $nick $+. }
  if (%betting == yes && %point.set == yes) {
    set %1roll $rand(1,6) | set %2roll $rand(1,6) | set %rolls $calc(%1roll + %2roll)
    /msg $chan 5,8 $+ 1 $+ $nick rolled a1 %1roll 5,8and a1 %2roll 5,8for a total of1 %rolls $+ 5.
    if (%rolls == %point) { set %money $calc(%bet * 2 + %money) | set %betting no | set %point.set no | /msg $chan 5,8 $+ 1 $+ $nick 5hit the point! | /msg $chan 5,8 $+ 1 $+ $nick 5has won 1$ $+ %bet $+ , 5for a total of 1$ $+ %money $+ 5. }
    if (%rolls == 7) { set %point.set no | set %betting no | set %point.set no | /msg $chan 5,8Lucky sevens eh? Better luck next time. | /msg $chan 5,8 $+ 1 $+ $nick 5has lost 1$ $+ %bet $+ , 5for a total of 1$ $+ %money $+ 5. | /halt }    
    if (%rolls != %point) { /msg $chan 5,8You did not hit the point 1 $+ $nick 5. Roll again. }  
  }
  if (%money == 0 && %point.set == no) { /rlevel dice.able | unset %point.set | unset %point | unset %money | unset %game.start | unset %betting | unset %bet | unset %1roll | unset %2roll | unset %rolls | set %game.start no | set %point.set no | set %betting no | /msg $chan 5,8Well. Looks like you ran out of luck $nick $+ . Better give some one else a chance. Type !dice to start. }
}
on *:TEXT:!rules:#:/notice $nick For the dice shooter, the objective of the game is to pitch a 7 or an 11 on the first roll (a win) and keep away from throwing a 2, 3 or 12 (a loss). If not an iota of these numbers (2, 3, 7, 11 or 12) is tossed on the first throw (the Come-out roll) then a Point is recognized (the point is the number rolled) alongside which the shooter plays. The shooter keeps on throwing in anticipation that one of two numbers is thrown, the Point number or a Seven. If the shooter rolls the Point before rolling a Seven he/she wins, however if the shooter throws a Seven prior to rolling the Point he/she loses.
