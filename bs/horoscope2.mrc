	

on *:text:*:#: {
  if (.h == $1) {
    if ($2) {
      if ($2 == set) {
        if ($3) {
          if ($3 == aries || $3 == taurus || $3 == gemini || $3 == cancer || $3 == leo || $3 == virgo || $3 == libra || $3 == scorpio || $3 == sagittarius || $3 == capricorn || $3 == aquarius || $3 == pisces) {  
            write -ds [ $+ [ $nick ] ] horousers.txt
            write horousers.txt $nick $3
            msg # $nick your horoscope preset is now set to: $3
            set %horosign $3
          }
          else { msg # You must specify an astrological sign to set it as a preset! | halt }
        }
      }
      else {
        if ($2 == aries || $2 == taurus || $2 == gemini || $2 == cancer || $2 == leo || $2 == virgo || $2 == libra || $2 == scorpio || $2 == sagittarius || $2 == capricorn || $2 == aquarius || $2 == pisces) {
          set %horosign $2
          set %horourl /horoscopes/details/ $+ $date(yyyy-mm-dd) $+ / $+ $2 $+ -daily-horoscope
        }
        else { msg # You must specify a proper astrological sign (aries, taurus, gemini, cancer, leo, virgo, libra, scorpio, sagittarius, capricorn, aquarius, pisces) or use ".h set sign" to set a preset. | halt }
      }
    }
    else {
      set %horosign $read(horousers.txt,s,$nick)
      if (!%horosign) { msg # To use ".h" command without any sign specified you must set a preset using ".h set sign" | halt }
    }
    set %horourl /horoscopes/details/ $+ $date(yyyy-mm-dd) $+ / $+ %horosign $+ -daily-horoscope
    if ($sock(horo)) .sockclose horo
    set %horochan $chan
    set %horonick $nick
    sockopen horo m.astrology.com 80
  }
}
on *:SOCKOPEN:horo: {
  sockwrite -nt $sockname GET %horourl HTTP/1.1
  sockwrite -nt $sockname Host: m.astrology.com
  sockwrite -nt $sockname $crlf
}
on *:SOCKREAD:horo: {
  if ($sockerr) {
    msg %chan Socket Error: $sockname $+ . Error code: $sockerr Please inform $me of this error message.
    halt
  }
  else {
    var %sockreader
    sockread %sockreader
    if (*<p>* iswm %sockreader && *</a>* !iswm %sockreader ) {
      set %horo $nohtml($nohtml(%sockreader))
      msg # /horoscope/ $+ %horosign $+ / 3= %horo
      unset %horo*
      sockclose horo
    }
  }
}
alias nohtml return $regsubex($1-,/(^[^<>]*\>)|(<[^<>]*>)|(<[^<>]*$)/g,)
