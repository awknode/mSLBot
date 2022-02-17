ON *:JOIN:#:{
  if ($nick == $me) { .timerjac. $+ # $+ . $+ $r(1,99999999999) 1 $r(120,400) jac | return }
  if (bot isin $nick) { return }
  $+(.timerh.,#,.,$nick) 0 3600 add.pts $+(#,.,$nick)
  add.pts $+(#,.,$nick)
}

ON *:PART:#: {
  if ($nick !== $me) {
    $+(.timerh.,#,.,$nick) off
  }
  elseif ($nick == $me) { .timerjac.* off }
}

ON !*:TEXT:!*:#: {
  tokenize 32 $strip($1-,burci)
  if ($1 == !totalrank) {
    var %f = h.ini
    if (!$isfile(%f)) { msg $chan [ $+ $nick $+ ]: Error, There is NOT any user on the database yet, file not exist! | return }
    if (!$lines(%f)) { msg $chan [ $+ $nick $+ ]: Error, There is NOT any user on the database yet, file is currently empty! | return }
    if (!$ini(%f,0)) { msg $chan [ $+ $nick $+ ]: Error, There is NOT any user on the database yet, file is empty! | return }
    if ($nick !isop $chan) { msg $chan [ $+ $nick $+ ]: You are NOT an channel moderator! | return }
    msg $chan [ $+ $nick $+ ]: There are $qt( $+ $ini(%f,0) $+ ) total nick(s) in the database.
  }
  if ($1 == !h) && ($nick isowner $chan) {
    if (!$2) { msg $chan [ $+ $nick $+ ]: You have $qt( $+ $iif($readini(h.ini,$+(#,.,$nick),h),$v1,0) $+ ) total h(s). }
    elseif ($2) {
      if ($nick isop #) {
        if ($2) && (!$3) && (!$readini(h.ini,$+(#,.,$2),h)) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) has NOT any h(s) yet! | return }
        if ($2) && (!$3) { msg $chan [ $+ $nick $+ ]: $2 has $qt( $+ $iif($readini(h.ini,$+(#,.,$2),h),$v1,0) $+ ) total h(s). | return }
        if ($0 < 3) { msg # Improper syntax. !h <add :: del > <user> <number> | return }
        writeini -n h.ini $+(#,.,$3) h $calc($readini(h.ini,$+(#,.,$3),h) $iif($2 == add,+,-) $iif($4 isnum,$4,1))
        msg $chan [ $+ $nick $+ ]: The $qt($3) now has $qt( $+ $iif($readini(h.ini,$+(#,.,$3),h),$v1,0) $+ ) total h(s).
      }
      else { msg $chan [ $+ $nick $+ ]: Access denied. }
    }
  }
  if ($1 == !hrank) {
    var %f = h.ini
    if (!$isfile(%f)) { msg $chan [ $+ $nick $+ ]: [Error]: DB does not exist. | return }
    if (!$lines(%f)) { msg $chan [ $+ $nick $+ ]: [Error]: DB is empty. | return }
    if (!$ini(%f,0)) { msg $chan [ $+ $nick $+ ]: [Error]: DB is currently empty. | return }
    if ($2) && ($2 == $nick) { goto me }
    if (!$2) {
      :me
      var %cn = $chan $+ . $+ $nick
      var %c = $readini(%f,%cn,h)
      if (%c <= 9) { msg $chan [ $+ $nick $+ ]: You are Rank1 with $qt(%c) h. - Earn $qt($calc(10 - %c)) more h to become a Rank2. }
      if (%c > 9) && (%c <= 19) { msg $chan [ $+ $nick $+ ]: You are Rank2 with $qt(%c) h. - Earn $qt($calc(20 - %c)) more h to become a Rank3. }
      if (%c > 19) && (%c <= 29) { msg $chan [ $+ $nick $+ ]: You are Rank3 with $qt(%c) h. - Earn $qt($calc(30 - %c)) more h to become a Rank4. }
      if (%c > 29) && (%c <= 39) { msg $chan [ $+ $nick $+ ]: You are Rank4 with $qt(%c) h. - Earn $qt($calc(40 - %c)) more h to become a Rank5. }
      if (%c > 39) && (%c <= 49) { msg $chan [ $+ $nick $+ ]: You are Rank5 with $qt(%c) h. - Earn $qt($calc(50 - %c)) more h to become a Rank6. }
      if (%c > 49) && (%c <= 59) { msg $chan [ $+ $nick $+ ]: You are Rank6 with $qt(%c) h. - Earn $qt($calc(60 - %c)) more h to become a Rank7. }
      if (%c > 59) && (%c <= 69) { msg $chan [ $+ $nick $+ ]: You are Rank7 with $qt(%c) h. - Earn $qt($calc(70 - %c)) more h to become a Rank8. }
      if (%c > 69) && (%c <= 79) { msg $chan [ $+ $nick $+ ]: You are Rank8 with $qt(%c) h. - Earn $qt($calc(80 - %c)) more h to become a Rank9. }
      if (%c > 79) && (%c <= 89) { msg $chan [ $+ $nick $+ ]: You are Rank9 with $qt(%c) h. - Earn $qt($calc(90 - %c)) more h to become a Rank10. }
      if (%c > 89) && (%c <= 99) { msg $chan [ $+ $nick $+ ]: You are Rank10 with $qt(%c) h. - Earn $qt($calc(100 - %c)) more h to become a Rank11. }
      if (%c > 99) && (%c <= 109) { msg $chan [ $+ $nick $+ ]: You are Rank11 with $qt(%c) h. - Earn $qt($calc(110 - %c)) more h to become a Rank12. }
      if (%c > 109) && (%c <= 119) { msg $chan [ $+ $nick $+ ]: You are Rank12 with $qt(%c) h. - Earn $qt($calc(120 - %c)) more h to become a Rank13. }
      if (%c > 119) && (%c <= 129) { msg $chan [ $+ $nick $+ ]: You are Rank13 with $qt(%c) h. - Earn $qt($calc(130 - %c)) more h to become a Rank14. }
      if (%c > 129) && (%c <= 139) { msg $chan [ $+ $nick $+ ]: You are Rank14 with $qt(%c) h. - Earn $qt($calc(140 - %c)) more h to become a Rank15. }
      if (%c > 139) && (%c <= 149) { msg $chan [ $+ $nick $+ ]: You are Rank15 with $qt(%c) h. - Earn $qt($calc(150 - %c)) more h to become a Rank16. }
      if (%c > 149) && (%c <= 159) { msg $chan [ $+ $nick $+ ]: You are Rank16 with $qt(%c) h. - Earn $qt($calc(160 - %c)) more h to become a Rank17. }
      if (%c > 159) && (%c <= 169) { msg $chan [ $+ $nick $+ ]: You are Rank17 with $qt(%c) h. - Earn $qt($calc(170 - %c)) more h to become a Rank18. }
      if (%c > 169) && (%c <= 179) { msg $chan [ $+ $nick $+ ]: You are Rank18 with $qt(%c) h. - Earn $qt($calc(180 - %c)) more h to become a Rank19. }
      if (%c > 179) && (%c <= 189) { msg $chan [ $+ $nick $+ ]: You are Rank19 with $qt(%c) h. - Earn $qt($calc(190 - %c)) more h to become a Rank20. }
      if (%c > 189) && (%c <= 199) { msg $chan [ $+ $nick $+ ]: You are Rank20 with $qt(%c) h. - Earn $qt($calc(200 - %c)) more h to become a Rank21. }
      if (%c > 199) && (%c <= 209) { msg $chan [ $+ $nick $+ ]: You are Rank21 with $qt(%c) h. - Earn $qt($calc(210 - %c)) more h to become a Rank22. }
      if (%c > 209) && (%c <= 219) { msg $chan [ $+ $nick $+ ]: You are Rank22 with $qt(%c) h. - Earn $qt($calc(220 - %c)) more h to become a Rank23. }
      if (%c > 219) && (%c <= 229) { msg $chan [ $+ $nick $+ ]: You are Rank23 with $qt(%c) h. - Earn $qt($calc(230 - %c)) more h to become a Rank24. }
      if (%c > 229) && (%c <= 239) { msg $chan [ $+ $nick $+ ]: You are Rank24 with $qt(%c) h. - Earn $qt($calc(240 - %c)) more h to become a Rank25. }
      if (%c > 239) && (%c <= 249) { msg $chan [ $+ $nick $+ ]: You are Rank25 with $qt(%c) h. - Earn $qt($calc(250 - %c)) more h to become a Rank26. }
      if (%c > 249) && (%c <= 259) { msg $chan [ $+ $nick $+ ]: You are Rank26 with $qt(%c) h. - Earn $qt($calc(260 - %c)) more h to become a Rank27. }
      if (%c > 259) && (%c <= 269) { msg $chan [ $+ $nick $+ ]: You are Rank27 with $qt(%c) h. - Earn $qt($calc(270 - %c)) more h to become a Rank28. }
      if (%c > 269) && (%c <= 279) { msg $chan [ $+ $nick $+ ]: You are Rank28 with $qt(%c) h. - Earn $qt($calc(280 - %c)) more h to become a Rank29. }
      if (%c > 279) && (%c <= 289) { msg $chan [ $+ $nick $+ ]: You are Rank29 with $qt(%c) h. - Earn $qt($calc(290 - %c)) more h to become a Rank30. }
      if (%c > 289) && (%c <= 299) { msg $chan [ $+ $nick $+ ]: You are Rank30 with $qt(%c) h. - Earn $qt($calc(300 - %c)) more h to become a Rank31. }
      if (%c > 299) && (%c <= 309) { msg $chan [ $+ $nick $+ ]: You are Rank31 with $qt(%c) h. - Earn $qt($calc(310 - %c)) more h to become a Rank32. }
      if (%c > 309) && (%c <= 319) { msg $chan [ $+ $nick $+ ]: You are Rank32 with $qt(%c) h. - Earn $qt($calc(320 - %c)) more h to become a Rank33. }
      if (%c > 319) && (%c <= 329) { msg $chan [ $+ $nick $+ ]: You are Rank33 with $qt(%c) h. - Earn $qt($calc(330 - %c)) more h to become a Rank34. }
      if (%c > 329) && (%c <= 339) { msg $chan [ $+ $nick $+ ]: You are Rank34 with $qt(%c) h. - Earn $qt($calc(340 - %c)) more h to become a Rank35. }
      if (%c > 339) && (%c <= 349) { msg $chan [ $+ $nick $+ ]: You are Rank35 with $qt(%c) h. - Earn $qt($calc(350 - %c)) more h to become a Rank36. }
      if (%c > 349) && (%c <= 359) { msg $chan [ $+ $nick $+ ]: You are Rank36 with $qt(%c) h. - Earn $qt($calc(360 - %c)) more h to become a Rank37. }
      if (%c > 359) && (%c <= 369) { msg $chan [ $+ $nick $+ ]: You are Rank37 with $qt(%c) h. - Earn $qt($calc(370 - %c)) more h to become a Rank38. }
      if (%c > 369) && (%c <= 379) { msg $chan [ $+ $nick $+ ]: You are Rank38 with $qt(%c) h. - Earn $qt($calc(380 - %c)) more h to become a Rank39. }
      if (%c > 379) && (%c <= 389) { msg $chan [ $+ $nick $+ ]: You are Rank39 with $qt(%c) h. - Earn $qt($calc(390 - %c)) more h to become a Rank40. }
      if (%c > 389) && (%c <= 399) { msg $chan [ $+ $nick $+ ]: You are Rank40 with $qt(%c) h. - Earn $qt($calc(400 - %c)) more h to become a Rank41. }
      if (%c > 399) && (%c <= 409) { msg $chan [ $+ $nick $+ ]: You are Rank41 with $qt(%c) h. - Earn $qt($calc(410 - %c)) more h to become a Rank42. }
      if (%c > 409) && (%c <= 419) { msg $chan [ $+ $nick $+ ]: You are Rank42 with $qt(%c) h. - Earn $qt($calc(420 - %c)) more h to become a Rank43. }
      if (%c > 419) && (%c <= 429) { msg $chan [ $+ $nick $+ ]: You are Rank43 with $qt(%c) h. - Earn $qt($calc(430 - %c)) more h to become a Rank44. }
      if (%c > 429) && (%c <= 439) { msg $chan [ $+ $nick $+ ]: You are Rank44 with $qt(%c) h. - Earn $qt($calc(440 - %c)) more h to become a Rank45. }
      if (%c > 439) && (%c <= 449) { msg $chan [ $+ $nick $+ ]: You are Rank45 with $qt(%c) h. - Earn $qt($calc(450 - %c)) more h to become a Rank46. }
      if (%c > 449) && (%c <= 459) { msg $chan [ $+ $nick $+ ]: You are Rank46 with $qt(%c) h. - Earn $qt($calc(460 - %c)) more h to become a Rank47. }
      if (%c > 459) && (%c <= 469) { msg $chan [ $+ $nick $+ ]: You are Rank47 with $qt(%c) h. - Earn $qt($calc(470 - %c)) more h to become a Rank48. }
      if (%c > 469) && (%c <= 479) { msg $chan [ $+ $nick $+ ]: You are Rank48 with $qt(%c) h. - Earn $qt($calc(480 - %c)) more h to become a Rank49. }
      if (%c > 479) && (%c <= 489) { msg $chan [ $+ $nick $+ ]: You are Rank49 with $qt(%c) h. - Earn $qt($calc(490 - %c)) more h to become a Rank50. }
      if (%c > 499) && (%c >= 500) { msg $chan [ $+ $nick $+ ]: You are MAX Rank50 with $qt(%c) h. }
    }
    elseif ($2) {
      var %cn = $chan $+ . $+ $2
      if ($2 == $me) { msg $chan [ $+ $nick $+ ]: Error, You cannot use this command to the bot! | return }
      if (!$ini(%f,%cn)) { msg $chan [ $+ $nick $+ ]: Error, The $qt( $+ $2 $+ ) user does NOT exist on the database! | return }
      var %c = $readini(%f,%cn,h)
      if (%c <= 9) { msg $chan [ $+ $2 $+ ]: The $qt( $+ $2 $+ ) user has Rank1 with $qt(%c) h. - Earn $qt($calc(10 - %c)) more h to become a Rank2. }
      if (%c > 9) && (%c <= 19) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank2 with $qt(%c) h. - Must earn $qt($calc(20 - %c)) more h to become a Rank3. }
      if (%c > 19) && (%c <= 29) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank3 with $qt(%c) h. - Must earn $qt($calc(30 - %c)) more h to become a Rank4. }
      if (%c > 29) && (%c <= 39) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank4 with $qt(%c) h. - Must earn $qt($calc(40 - %c)) more h to become a Rank5. }
      if (%c > 39) && (%c <= 49) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank5 with $qt(%c) h. - Must earn $qt($calc(50 - %c)) more h to become a Rank6. }
      if (%c > 49) && (%c <= 59) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank6 with $qt(%c) h. - Must earn $qt($calc(60 - %c)) more h to become a Rank7. }
      if (%c > 59) && (%c <= 69) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank7 with $qt(%c) h. - Must earn $qt($calc(70 - %c)) more h to become a Rank8. }
      if (%c > 69) && (%c <= 79) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank8 with $qt(%c) h. - Must earn $qt($calc(80 - %c)) more h to become a Rank9. }
      if (%c > 79) && (%c <= 89) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank9 with $qt(%c) h. - Must earn $qt($calc(90 - %c)) more h to become a Rank10. }
      if (%c > 89) && (%c <= 99) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank10 with $qt(%c) h. - Must earn $qt($calc(100 - %c)) more h to become a Rank11. }
      if (%c > 99) && (%c <= 109) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank11 with $qt(%c) h. - Must earn $qt($calc(110 - %c)) more h to become a Rank12. }
      if (%c > 109) && (%c <= 119) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank12 with $qt(%c) h. - Must earn $qt($calc(120 - %c)) more h to become a Rank13. }
      if (%c > 119) && (%c <= 129) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank13 with $qt(%c) h. - Must earn $qt($calc(130 - %c)) more h to become a Rank14. }
      if (%c > 129) && (%c <= 139) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank14 with $qt(%c) h. - Must earn $qt($calc(140 - %c)) more h to become a Rank15. }
      if (%c > 139) && (%c <= 149) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank15 with $qt(%c) h. - Must earn $qt($calc(150 - %c)) more h to become a Rank16. }
      if (%c > 149) && (%c <= 159) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank16 with $qt(%c) h. - Must earn $qt($calc(160 - %c)) more h to become a Rank17. }
      if (%c > 159) && (%c <= 169) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank17 with $qt(%c) h. - Must earn $qt($calc(170 - %c)) more h to become a Rank18. }
      if (%c > 169) && (%c <= 179) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank18 with $qt(%c) h. - Must earn $qt($calc(180 - %c)) more h to become a Rank19. }
      if (%c > 179) && (%c <= 189) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank19 with $qt(%c) h. - Must earn $qt($calc(190 - %c)) more h to become a Rank20. }
      if (%c > 189) && (%c <= 199) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank20 with $qt(%c) h. - Must earn $qt($calc(200 - %c)) more h to become a Rank21. }
      if (%c > 199) && (%c <= 209) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank21 with $qt(%c) h. - Must earn $qt($calc(210 - %c)) more h to become a Rank22. }
      if (%c > 209) && (%c <= 219) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank22 with $qt(%c) h. - Must earn $qt($calc(220 - %c)) more h to become a Rank23. }
      if (%c > 219) && (%c <= 229) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank23 with $qt(%c) h. - Must earn $qt($calc(230 - %c)) more h to become a Rank24. }
      if (%c > 229) && (%c <= 239) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank24 with $qt(%c) h. - Must earn $qt($calc(240 - %c)) more h to become a Rank25. }
      if (%c > 239) && (%c <= 249) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank25 with $qt(%c) h. - Must earn $qt($calc(250 - %c)) more h to become a Rank26. }
      if (%c > 249) && (%c <= 259) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank26 with $qt(%c) h. - Must earn $qt($calc(260 - %c)) more h to become a Rank27. }
      if (%c > 259) && (%c <= 269) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank27 with $qt(%c) h. - Must earn $qt($calc(270 - %c)) more h to become a Rank28. }
      if (%c > 269) && (%c <= 279) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank28 with $qt(%c) h. - Must earn $qt($calc(280 - %c)) more h to become a Rank29. }
      if (%c > 279) && (%c <= 289) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank29 with $qt(%c) h. - Must earn $qt($calc(290 - %c)) more h to become a Rank30. }
      if (%c > 289) && (%c <= 299) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank30 with $qt(%c) h. - Must earn $qt($calc(300 - %c)) more h to become a Rank31. }
      if (%c > 299) && (%c <= 309) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank31 with $qt(%c) h. - Must earn $qt($calc(310 - %c)) more h to become a Rank32. }
      if (%c > 309) && (%c <= 319) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank32 with $qt(%c) h. - Must earn $qt($calc(320 - %c)) more h to become a Rank33. }
      if (%c > 319) && (%c <= 329) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank33 with $qt(%c) h. - Must earn $qt($calc(330 - %c)) more h to become a Rank34. }
      if (%c > 329) && (%c <= 339) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank34 with $qt(%c) h. - Must earn $qt($calc(340 - %c)) more h to become a Rank35. }
      if (%c > 339) && (%c <= 349) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank35 with $qt(%c) h. - Must earn $qt($calc(350 - %c)) more h to become a Rank36. }
      if (%c > 349) && (%c <= 359) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank36 with $qt(%c) h. - Must earn $qt($calc(360 - %c)) more h to become a Rank37. }
      if (%c > 359) && (%c <= 369) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank37 with $qt(%c) h. - Must earn $qt($calc(370 - %c)) more h to become a Rank38. }
      if (%c > 369) && (%c <= 379) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank38 with $qt(%c) h. - Must earn $qt($calc(380 - %c)) more h to become a Rank39. }
      if (%c > 379) && (%c <= 389) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank39 with $qt(%c) h. - Must earn $qt($calc(390 - %c)) more h to become a Rank40. }
      if (%c > 389) && (%c <= 399) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank40 with $qt(%c) h. - Must earn $qt($calc(400 - %c)) more h to become a Rank41. }
      if (%c > 499) && (%c <= 409) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank41 with $qt(%c) h. - Must earn $qt($calc(410 - %c)) more h to become a Rank42. }
      if (%c > 409) && (%c <= 419) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank42 with $qt(%c) h. - Must earn $qt($calc(420 - %c)) more h to become a Rank43. }
      if (%c > 419) && (%c <= 429) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank43 with $qt(%c) h. - Must earn $qt($calc(430 - %c)) more h to become a Rank44. }
      if (%c > 429) && (%c <= 439) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank44 with $qt(%c) h. - Must earn $qt($calc(440 - %c)) more h to become a Rank45. }
      if (%c > 439) && (%c <= 449) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank45 with $qt(%c) h. - Must earn $qt($calc(450 - %c)) more h to become a Rank46. }
      if (%c > 449) && (%c <= 459) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank46 with $qt(%c) h. - Must earn $qt($calc(460 - %c)) more h to become a Rank47. }
      if (%c > 459) && (%c <= 469) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank47 with $qt(%c) h. - Must earn $qt($calc(470 - %c)) more h to become a Rank48. }
      if (%c > 469) && (%c <= 479) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank48 with $qt(%c) h. - Must earn $qt($calc(480 - %c)) more h to become a Rank49. }
      if (%c > 479) && (%c <= 489) { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user has Rank49 with $qt(%c) h. - Must earn $qt($calc(490 - %c)) more h to become a Rank50. }
      if (%c > 499) && (%c >= 500 { msg $chan [ $+ $nick $+ ]: The $qt( $+ $2 $+ ) user is MAX Rank50 with $qt(%c) h. }
    }
  }
}

alias -l jac {
  if ($status !== connected) { return }
  var %n = $nick(#,0)
  var %i = 1
  while (%i <= %n) {
    var %z = $nick(#,%i)
    if ($nick(#,$me) = $nick(#,%z)) || (bot isin $nick(#,%i)) { goto next }
    writeini -n h.ini $nick(#,%i) h $calc($readini(h.ini,$nick(#,%i),h) + 1)
    :next
    inc %i
  }
}

alias -l add.pts {
  if ($status !== connected) { return }
  writeini -n h.ini $1 h $calc($readini(h.ini,$1,h) + 1)
}
