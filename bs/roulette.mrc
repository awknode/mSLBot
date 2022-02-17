On *:TEXT:!Roulette:#: {
  if ((%floodroulette) || ($($+(%,floodroulette.,$nick),2))) { return }
  set -u1 %floodroulette On
  set -u1 %floodroulette. $+ $nick On
  if ($nick !isop #) msg $chan Bitch you know you aren't right.
  else {
    var %randnumber = $rand(1,4)
    if (%randnumber == 1) {
      msg $chan BOOM BITCH!!! IT SHOT YOU RIGHT IN THE ASS! and a bullet goes WAY up there. $nick is shaking so badly that it kissed his anus and now $nick $+ 's just wishing he could have gotten dinner first. 
      kick $nick BOOM BITCH!!
    }
    elseif (%randnumber == 2) { 
      msg $chan Roulette CLICK, Empty you lucky motherfucker you. You have a set of balls on you though I'll give you that. You are forced to live with rockho for eternity $nick $+ .
    }
    elseif (%randnumber == 3) { 
      msg $chan WHAMMY!!! You were just photographed taking a moneyshot at your mother and trying to get your father to clean it up. You are disgrace to this world and you need: 
      kick $nick WHAMMY HOE!!
    }
    elseif (%randnumber == 4) {
      msg $chan $nick starts to shake, then tries to pull the trigger but he 6PUSSIED OUT!!! $nick drops the gun, and runs off crying like a little 4BITCH. Man up hoe. That's Roulette. 
    }
  }
  }	
