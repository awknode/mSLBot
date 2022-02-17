alias average {
  var %numbers = $1
  if ($prop == mean || !$prop) {
    tokenize 32 %numbers
    return $calc(($replace(%numbers, $chr(32), $chr(43))) / $0)
  }
  if ($prop == median) {
    %numbers = $sorttok(%numbers, 32, n)
    tokenize 32 %numbers
    var %median = $ceil($calc($0 / 2))
    if (!$calc($0 % 2)) {
      var %m = $gettok(%numbers, %median, 32)
      var %n = $gettok(%numbers, $calc(%median + 1), 32)
      return $calc((%m + %n) / 2)
    }
    return %median
  }
  if ($prop == mode) {
    %numbers = $sorttok(%numbers, 32, nr)
    var %i = $numtok(%numbers, 32)
    var %hi = 0
    while (%i) {
      var %num = $gettok(%numbers, %i , 32)
      var %match = $matchtok(%numbers, %num, 0, 32)
      if (%match > %hi) %hi = $ifmatch
      else if (%match == %hi) %hi = %hi and $ifmatch
      else %hi = null
      dec %i
    }
    return %hi
  }
  if ($prop == range) {
    %numbers = $sorttok(%numbers, 32, n)
    var %hi = $gettok(%numbers, $numtok(%numbers, 32), 32)
    var %lo = $gettok(%numbers, 1, 32)
    return $calc(%hi - %lo)
  }
}
