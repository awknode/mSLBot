on $*:text:/[$](explain|regex) */Si:#: {
  if ($regml(1) == explain) && ($2) explain $chan $2-
  elseif ($regml(1) == regex) && ($3) regex.match $chan $2-
}
alias explain regex.maketree $iif($1 ischan,$1 $replace($2-,$chr(32),\x20),$replace($1-,$chr(32),\x20))
alias -l regex.msg .timerregex. $+ $+($r(a,z),$r(a,z),$r(0,9),$r(0,9)) 1 $calc($iif($regex.timer(regex.*),$v1,-2) +2) regex.msg2 $1-
alias -l regex.msg2 {
  msg $1-
  return
  :error
  reseterror
}
alias -l regex.timer {
  var %a = 1,%x,%r
  while ($timer(%a)) {
    var %r = $regsubex($v1,/((?<!^\Q $+ $left($1,-1) $+ \E).)+/i,$null)
    if (%r) inc %x
    inc %a
  }
  return $iif(%x,%x,0)
}
alias -l regex.echo if ($2) !echo $1-
alias -l regex.MakeTree {
  var %target = $iif($1 != $2 && $2,$1,regex), %pattern = $iif(!$2,$1,$2)
  var %r = $regex(%pattern,/^\s*+(?:(m)(.)|()(\/)|()())/), %sep = $replace($regml(2),\,\\,',\'), %m = $regml(1), %notsep = $iif(%sep != $null,$+($chr(40),?!,%sep,$chr(41)))
  if (%sep != $null && $regex(%pattern,m'\s*+ %m %sep .* %sep [gisSmoXAU]*+ x [gisSmoxXAU]*+$'x)) {
    %r = $regsub(%pattern,/^\s++/,,%pattern)
    %r = m'((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |[^\s\[\]\\] )*+) \s++ 'xg
    %r = $regsub(%pattern,%r,\1,%pattern)
    %r = m'((?:^ %m %sep |(?<!^)\G) (?: \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:[^cQ]|c.) |\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |[^\#\[\]\\] )*+) \# .*( $iif(%sep != $null,%sep [gisSmoxXAU]*+$) )'xg
    %r = $regsub(%pattern,%r,\1\2,%pattern)
  }
  set -nl %r m'^\s*+ %m %sep ( ( (?: \| |( \(\?\#[^\)]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?:\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?:(?:>|[-ismxXU]*+:|<?[=!]|P<[^>]++>)(?2)|[-ismxXU]*+|R|\d++|\((?:\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\]\\] ) (?:(?:[*+?]|\{\d++(?:,\d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? ) %sep ([gisSmoxXAU]*+)$'x
  if (!$regex(%pattern,%r)) { $iif($me ison %target,regex.msg2 $v2,regex.echo -a) $regex.ShowErrorIn(%target,%pattern,%sep,%m,%notsep) }
  elseif (%target != $null && $left(%target,1) != @) {
    var %pattern = $regml(1), %options = $regml(4)
    set -u0 %regex.BRs 0
    if ($hget(%target)) hdel -w %target Tree.*
    %r = $regex.Explain(%target,%pattern,1,$iif(i isincs %options,$true,$false),$iif(s isincs %options,$true,$false),$iif(m isincs %options,$true,$false),$iif(x isincs %options,$true,$false),$iif(X isincs %options,$true,$false),$iif(U isincs %options,$true,$false))
    %r = $regex.ExplainModifiers(%target,%options,1)
    regex.Hash2Tree %target
  }
}
alias -l regex.ShowErrorIn {
  var %target = $1, %pattern = $2, %sep = $3, %m = $4, %notsep = $5, %ingroup = $6, %gstart, %gend, %r
  var %longdesc = $iif($window(%target) != $null,$true,$false), %cmd = $iif(%longdesc || %target ischan,msg %target,return)
  if (!%ingroup) { %r = $regex(%pattern,m'^(\s*+ %m %sep ( (?: \| |( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^] |(?: \[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?:(?:>|[-ismxXU]*+:|<?[=!]|P<[^>]++>)(?2)|[-ismxXU]*+|R|\d++|\((?:\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\]\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*+)? )'x) }
  if (!%ingroup && $len($regml(1)) == $len(%pattern) && %sep != $null) { %cmd 5Expected `6 $+ %sep $+ 5` to end pattern $+(%pattern,4here) }
  else {
    if (!%ingroup) %r = $regex(patttrig,%pattern,m'^(\s*+ %m %sep ( (?: \|| ( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?: \[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?:(?:>|[-ismxXU]*+:|<?[=!]|P<[^>]++>)(?2)|[-ismxXU]*+|R|\d++|\((?:\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\]\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*)? %sep [gisSmoxXAU]*+ )'x)
    if ( !%ingroup && %r > 0 && %sep != $null && $len($regml(patttrig,1)) != $len(%pattern) && $regex(%pattern,m'^(\s*+ %m %sep ( (?:(?: \[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |(?:\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[|$^] )(?![?*+{]) |\\c. |\\[^QcbBAZzGE] |\((?:\?(?!\#))?+(?2)\)| %notsep [^^$|*+?{}()\[\]\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?+)?+ )*+ (?:\\Q(?:(?!\\E).)*)? ) %sep [a-zA-Z]*+ $ )'x) ) { %cmd 5Invalid modifier in $+($regml(patttrig,1),4here,$mid(%pattern,$calc($len($regml(patttrig,1)) + 1))) }
    else {
      if ( %ingroup ) {
        %gstart = (
        %gend = )
      }
      else {
        %r = $regsub(%pattern,/^(\s*+ %m %sep )(.*)( %sep .*)$/x,\2,%pattern)
        %gstart = $regml(1)
        %gend = $regml(3)
      }
      if ( $regex(%pattern,m'^( ( (?: \|| ( \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?: \[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?:(?:>|[-ismxXU]*+:|<?[=!]|P<[^>]++>)(?2)|[-ismxXU]*+|R|\d++|\((?:\d++|\?<?[=!](?2))\)(?2))|(?!\?)(?2))\)| %notsep [^^$|*+?{}()\[\]\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ ) )*+ ) (?:\\Q(?:(?!\\E).)*+)?+ ) (.)'x) ) {
        var %lastbr = $regml(0), %b4 = $regml(1), %after = $mid(%pattern,$regml(%lastbr).pos)
        if ( $regml(%lastbr) == $null ) { %cmd 4Unknown syntax error (I can't find the position) }
        elseif ( $v1 != $chr(40) ) {
          var %char = Invalid character
          if ( $v1 isin {}+*? ) { %char = Quantifier with no preceding token }
          elseif ( $v1 == [[ ) {
            if ( $mid(%pattern,$calc($regml(4).pos + 1),1) == ]] ) { %char = Empty charater class }
            else { %char = Unbalanced character class }
          }
          elseif ( $v1 == ]] ) { %char = Unbalanced character class }
          elseif ( $v1 == $chr(41) ) {
            %char = Unbalanced bracket
            %r = /([^\(]*+) \( ( \?\#[^ $+ $chr(41) $+ ]*+ |(?!\?\#)(?:\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\]|\\Q(?:(?!\\E).)*+\\E|\\(?:c.|[^Qc])|[^()\\]|\((?2)\) )*+ ) \) /xg
            %r = $regsub(%b4,%r,\1(\2),%b4)
            %after = 6) $+ $mid(%after,2)
          }
          %cmd 5 $+ %char in $+ $iif(%ingroup,$chr(32) $+ the group) $+ : $+(%gstart,%b4,4here,%after,%gend)
        }
        else {
          %r = /^\((?:(?!\?)|\?(?:\#|>|[-ismxXU]*+:|<?[=!]|P<[^>]++>|[-ismxXU]*+|R|\d++|\((?:\d++|\?<?[=!])))/
          if ( !$regex(%after,%r) ) { %cmd 5Invalid construct in $+ $iif(%ingroup,$chr(32) $+ nested group) $+ : $+(%gstart,%b4,4here,%after,%gend) }
          else {
            %r = /^\( ( (?:\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:c.|[^Qc])|[^()]|\((?!\?\#)(?1)\))*+ ) \)/x
            if ( $regsub(%after,%r,4(\1)4,%after) ) {
              if ( %longdesc ) {
                %cmd 5Syntax error in $iif(%ingroup,nested) group $+(%gstart,%b4,%after,%gend)
                %r = $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep)
              }
              else { %cmd $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep) }
            }
            else {
              %r = /^\( ( (?:\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\(?:c.|[^Qc])|[^()]|\((?!\?\#)(?1)\))*+ ) \)/x
              if ( $regsub(%after,%r,4(\1)4,%after) ) {
                if ( %longdesc ) {
                  %cmd 5Syntax error in $iif(%ingroup,nested) group $+(%gstart,%b4,%after,%gend)
                  %r = $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep)
                }
                else { %cmd $regex.ShowErrorInGroup(%target,$regml(1),%sep,%m,%notsep) }
              }
              else {
                %r = /([^\(]*+) \( ( \?\#[^ $+ $chr(41) $+ ]*+ |(?:\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\Q(?:(?!\\E).)*+\\E|\\c.|\\[^Qc]|[^()\\]|\((?2)\) )*+ ) \) /xg
                %r = $regsub($mid(%after,2),%r,\1(\2),%after)
                %cmd 5Unbalanced group starts in $+(%gstart,%b4,4here,6,$chr(40),,%after,%gend)
              }
            }
          }
        }
      }
      else { %cmd 4Unknown syntax error (I can't find the position) }
    }
  }
  return
  :error
  regex.echo -a Your pattern caused an error in the script: $error
  reseterror
}
alias -l regex.ShowErrorInGroup { return $regex.ShowErrorIn($1,$2,$3,$4,$5,$true) }
alias -l regex.Explain {
  var %target = $1, %pattern = $2, %lvl = $3
  var %imode = $4, %smode = $5, %mmode = $6, %xmode = $7, %XXmode = $8, %Umode = $9
  var %N, %i, %r, %null = (null, matches any position)
  if ( %pattern == $null ) { $regex.RefOut(%target,%lvl) %null %quant }
  elseif ( $regex(%pattern,m'( \G ( (?: \(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\[bBAZzG] |[$^]| (?:\[(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^QcbBAZzGE]) |\((?:\?(?!\#))?+(?:\||(?2))*+\)| %notsep [^^$|*+?{()\[\]\\] ) (?:(?:[*+?]|\{\d++(?: $chr(44) \d*+)?\})[?+]?)?+ )*+ ) (?:\\Q(?:(?!\\E).)*+$)?+ ) (\|)'gx) ) {
    %N = $v1
    %i = $regml(0)
    set -nl %patt.alt. $+ %lvl $+ . $+ $calc(%N + 1) $mid(%pattern,$calc($regml(%i).pos + $len($regml(%i))))
    %i = 0
    While (%i < %N) {
      inc %i
      set -nl %patt.alt. $+ %lvl $+ . $+ %i $regml($calc((%i - 1) * 3 + 1))
    }
    inc %N
    %i = 0
    While (%i < %N) {
      inc %i
      %r = $regex.Explain.Show(%target,%patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%lvl,$ord(%i) alternation: %patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
    }
  }
  elseif ( $regex(%pattern,m'\G(( \[(?!\\?[\\"^$|.*+?{}()\[\]\/]\])(?:\\(?:c.|[^c])|\[:[^\]]*:\]|[^\]])++\] |\\(?:c.|[^Qcx^$|.*+?{()\[\]\\]) |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\((?:\?(?!\#))?+(?:\||(?1))*+\)| [$^.] |(?:\\(?:[|.$^*+?{()\[\]\\]|x[\da-fA-F]{1,2})|[^^$|.*+?{()\[\]\\]|\[\\?[\\"^$|*+?{}()\[\]\/]\]) (?:(?:\\(?:[|.$^*+?{()\[\]\\]|x[\da-fA-F]{1,2}+)|[^^$|.*+?{()\[\]\\]|\[\\?[\\"^$|.*+?{}()\[\]\/]\])+(?![?*+{]))? |\\Q(?:(?!\\E).)*+(?:\\E|$) ) (?:([*+?]|\{\d++(?: $chr(44) \d*+)?+\})([?+]?+)|()()) )'gx) ) {
    %N = $v1
    %i = 0
    var %j = 0, %refout, %quant
    While (%i < %N) {
      inc %i
      inc %j 2
      set -nl %patt.alt. $+ %lvl $+ . $+ %i $regml(%j)
      inc %j
      set -nl %patt.quant. $+ %lvl $+ . $+ %i $regml(%j)
      inc %j
      set -nl %patt.lazy. $+ %lvl $+ . $+ %i $regml(%j)
    }
    %i = 0
    While (%i < %N) {
      inc %i
      var %token = %patt.alt. [ $+ [ %lvl ] $+ . $+ [ %i ] ]
      %refout = $regex.RefOut(%target,%lvl)
      %quant = $regex.Explain.Quantifiers(%patt.quant. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%patt.lazy. [ $+ [ %lvl ] $+ . $+ [ %i ] ] ,%Umode)
      if ( $regex(%token,/^\(\?([-ismxXU]*+):(.*)\)$/) ) {
        if ( $regml(1) == $null ) { %r = $regex.Explain.Show(%target,$regml(2),%lvl,Group %token %quant,%imode,%smode,%mmode,%xmode,%XXmode,%Umode) }
        else {
          var %groupmodes = $regml(1), %grouppattern = $regml(2)
          %refout Group %token %quant
          %r = $regex.ExplainModifiers(%target,%groupmodes,$calc(%lvl + 1))
          var %gimode = %imode,%gsmode = %smode,%gmmode = %mmode,%gxmode = %xmode,%gXXmode = %XXmode,%gUmode = %Umode
          if ( (%gimode) && ($regex(%groupmodes,/-.*i/) == 1) ) { %gimode = $false }
          elseif ( (!%gimode) && ($regex(%groupmodes,/^[^-]*i/) == 1) ) { %gimode = $true }
          if ( (%gsmode) && ($regex(%groupmodes,/-.*s/) == 1) ) { %gsmode = $false }
          elseif ( (!%gsmode) && ($regex(%groupmodes,/^[^-]*s/) == 1) ) { %gsmode = $true }
          if ( (%gmmode) && ($regex(%groupmodes,/-.*m/) == 1) ) { %gmmode = $false }
          elseif ( (!%gmmode) && ($regex(%groupmodes,/^[^-]*m/) == 1) ) { %gmmode = $true }
          if ( (%gxmode) && ($regex(%groupmodes,/-.*x/) == 1) ) { %gxmode = $false }
          elseif ( (!%gimode) && ($regex(%groupmodes,/^[^-]*x/) == 1) ) { %gimode = $true }
          if ( (%gXXmode) && ($regex(%groupmodes,/-.*X/) == 1) ) { %gXXmode = $false }
          elseif ( (!%gXXmode) && ($regex(%groupmodes,/^[^-]*X/) == 1) ) { %gXXmode = $true }
          if ( (%gUmode) && ($regex(%groupmodes,/-.*U/) == 1) ) { %gUmode = $false }
          elseif ( (!%gUmode) && ($regex(%groupmodes,/^[^-]*U/) == 1) ) { %gUmode = $true }
          %r = $regex.Explain.Recurse(%target,%grouppattern,%lvl,%gimode,%gsmode,%gmmode,%gxmode,%gXXmode,%gUmode)
        }
      }
      elseif ( $regex(%token,/^\(\?([-ismxXU]++)\)$/) ) {
        var %groupmodes = $regml(1)
        %refout %token Modifiers
        %r = $regex.ExplainModifiers(%target,%groupmodes,$calc(%lvl + 1))
        if ( (%imode) && ($regex(%groupmodes,/-.*i/) == 1) ) { %imode = $false }
        elseif ( (!%imode) && ($regex(%groupmodes,/^[^-]*i/) == 1) ) { %imode = $true }
        if ( (%smode) && ($regex(%groupmodes,/-.*s/) == 1) ) { %smode = $false }
        elseif ( (!%smode) && ($regex(%groupmodes,/^[^-]*s/) == 1) ) { %smode = $true }
        if ( (%mmode) && ($regex(%groupmodes,/-.*m/) == 1) ) { %mmode = $false }
        elseif ( (!%mmode) && ($regex(%groupmodes,/^[^-]*m/) == 1) ) { %mmode = $true }
        if ( (%xmode) && ($regex(%groupmodes,/-.*x/) == 1) ) { %xmode = $false }
        elseif ( (!%imode) && ($regex(%groupmodes,/^[^-]*x/) == 1) ) { %imode = $true }
        if ( (%XXmode) && ($regex(%groupmodes,/-.*X/) == 1) ) { %XXmode = $false }
        elseif ( (!%XXmode) && ($regex(%groupmodes,/^[^-]*X/) == 1) ) { %XXmode = $true }
        if ( (%Umode) && ($regex(%groupmodes,/-.*U/) == 1) ) { %Umode = $false }
        elseif ( (!%Umode) && ($regex(%groupmodes,/^[^-]*U/) == 1) ) { %Umode = $true }
      }
      elseif ( $regex(%token,/^\((?![?#])(.*)\)$/) ) {
        inc -u0 %regex.BRs
        %r = $regex.Explain.Show(%target,$regml(1),%lvl,$ord(%regex.BRs) Backreference %token %quant,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\?=(.*)\)$/) ) {
        %refout %token Positive LookAhead
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\?!(.*)\)$/) ) {
        %refout %token Negative LookAhead
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\?<=(.*)\)$/) ) {
        %refout %token Positive LookBehind
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\?<!(.*)\)$/) ) {
        %refout %token Negative LookBehind
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\?>(.*)\)$/) ) {
        %refout %token Atomic Group %quant
        %r = $regex.Explain.Recurse(%target,$regml(1),%lvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
      }
      elseif ( $regex(%token,/^\(\? (?#br1=cond)( \( ( (?: \[(?:\\c.|\\[^c]|\[:[^\]]*:\]|[^\]])++\] |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\c. |\\[^Qc] |\(\??(?2)\)| [^()\[\]] )*+ ) \) ) (?#br3=true)(( (?: \[(?:\\c.|\\[^c]|\[:[^\]]*:\]|[^\]])++\] |\(\?\#[^ $+ $chr(41) $+ ]*+\) |\\Q(?:(?!\\E).)*+\\E |\\c. |\\[^Qc] |\(\??(?:\||(?4))*+\)| [^|()\[\]] )*+ )) (?#br5=[|false]?) (?:\|(.*))?\) $ /x) ) {
        var %pifcond = $regml(1), %piftrue = $regml(3), %piffalseexists = $iif($regml(0) >= 5,$true,$false), %piffalse = $regml(5), %newlvl = $calc(%lvl + 1), %newrefout = $regex.RefOut(%target,%newlvl)
        %refout %token IF clause %quant
        if ( $regex(%pifcond,/^\((\d++)\)$/) ) { %newrefout Condition: %pifcond True if the backreference $regml(1) is set }
        elseif ( $regex(%pifcond,/^\(\?(<?)([=!])(.*)\)$/) ) {
          %newrefout Condition: %pifcond Evaluates the $iif($regml(1) == !,negative,positive) look $+ $iif($regml(1) == $null,ahead,behind)
          %r = $regex.Explain.Recurse(%target,$regml(3),%newlvl,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        }
        else { %newrefout Condition: %pifcond 4Error: It should be a zero width assertion }
        %r = $regsub(%piftrue,/^\(\?:(.*)\)$/,\1,%piftrue))
        %r = $regex.Explain.Show(%target,%piftrue,%newlvl,True: %piftrue,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        if ( %piffalseexists ) {
          %r = $regsub(%piffalse,/^\(\?:(.*)\)$/,\1,%piffalse))
          %r = $regex.Explain.Show(%target,%piffalse,%newlvl,False: %piffalse,%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
        }
      }
      elseif ( $regex(%token,/^\(\?#([^ $+ $chr(41) $+ ]*+)\)$/) ) { %refout Comment: $regml(1) }
      elseif ( $regex(%token,/^\\(\d++)$/) && $regml(1) isnum 1 - %regex.BRs ) { %refout %token Matches text saved in BackRef $regml(1) %quant }
      elseif ( $regex(%token,/^\((\d++)\)$/) && $regml(1) isnum 1 - %regex.BRs ) { %refout %token Recurse BackRef $regml(1) %quant }
      elseif ( %token == (?R) ) { %refout %token Recurse the whole pattern %quant }
      elseif ( $regex(%token,/^\[\^(.*)\]$/) ) { %refout Negated char class %token %quant matches any char except: $regml(1) }
      elseif ( $regex(%token,/^\[(.*)\]$/) ) { %refout Char class %token %quant matches one of the following chars: $regml(1) }
      elseif ( $regex.Explain.Literal(%token,%imode,%smode,%mmode,%xmode,%XXmode,%Umode) != $null ) { %refout %token %quant $v1 }
      else { %refout %token %quant 5(*) not described yet }
    }
  }
  else { $regex.RefOut(%target,%lvl) %token 4Unrecognized structure in %pattern 5No description for it yet (nothing's perfect) }
}
alias -l regex.Explain.Recurse { var %r = $regex.Explain($1,$2,$calc($3 + 1),$4,$5,$6,$7,$8,$9) }
alias -l regex.RefOut Return { regex.Hash.AddTree $1 $2 }
alias -l regex.Hash.AddTree {
  var %regex.pat2 = $1, %text = $2-, %i = $hget(%regex.pat2,Tree.0)
  if (%i == $null) { %i = 1 }
  else { inc %i }
  hadd -m %regex.pat2 Tree.0 %i
  hadd %regex.pat2 Tree. $+ %i %text
}
alias -l regex.Hash2Tree {
  var %regex.pat2 = $1, %i = $hget(%regex.pat2,Tree.0), %lvl, %txt, %y = 1
  while (%y <= %i) {
    tokenize 32 $strip($hget(%regex.pat2,Tree. $+ %y))
    if ( %lvl == $null ) { %lvl = $1 }
    elseif ( $1 < %lvl ) { %lvl = $1 }
    $iif($me ison %regex.pat2,regex.msg %regex.pat2,regex.echo -a) $regex.lvl($1,%lvl) $2-
    inc %y
  }
}
alias -l regex.lvl {
  var %blank = $calc($2 - 1), %branch = $calc($1 - %blank - 1)
  return $+($chr(160),$str($str($chr(160),2),%blank),$str($+(,$chr(160)),%branch),)
}
alias -l regex.Explain.Show {
  var %target = $1, %pattern = $2, %lvl = $3, %expl = $4, %expl.lit, %r
  var %imode = $5, %smode = $6, %mmode = $7, %xmode = $8, %XXmode = $9, %Umode = $10
  %expl.lit = $regex.Explain.Literal(%pattern)
  if (%expl.lit == $null) {
    $regex.RefOut(%target,%lvl) %expl
    %r = $regex.Explain(%target,%pattern,$calc(%lvl + 1),%imode,%smode,%mmode,%xmode,%XXmode,%Umode)
  }
  else { $regex.RefOut(%target,%lvl) %expl %expl.lit }
}
alias -l regex.Explain.Literal {
  var %pattern = $1, %token = %pattern, %null = (null, matches any position), %r
  var %imode = $2, %smode = $3, %mmode = $4, %xmode = $5, %XXmode = $6, %Umode = $7
  %r = $regsub(patttriglit,%token,/^\(\?\:(.*)\)$/,\1,%pattern)
  if ( %token == $null ) { return %null }
  elseif ( $v1 == ^ ) { return Start of $iif(%mmode,line,string) }
  elseif ( $v1 == $ ) { return End of $iif(%mmode,line,string) }
  elseif ( $v1 === \b ) { return Word boundary: match in between (^\w|\w$|\W\w|\w\W) }
  elseif ( $v1 === \B ) { return Negated word boundary: match any position where \b doesn't match }
  elseif ( $v1 === \A ) { return Start of string }
  elseif ( $v1 === \Z ) { return End of string }
  elseif ( $v1 === \z ) { return Absolute end of string }
  elseif ( $v1 === \G ) { return End of previous match or start of string (useful with the global modifier) }
  elseif ( $v1 == . ) { return Any character $iif(!%smode,(except newline)) %quant }
  elseif ( $v1 === \d ) { return Digit [0-9] %quant }
  elseif ( $v1 === \D ) { return Any character that's not a digit %quant }
  elseif ( $v1 === \w ) { return Word character [a-zA-Z_\d] %quant }
  elseif ( $v1 === \W ) { return Negated word character [^a-zA-Z_\d] %quant }
  elseif ( $v1 === \s ) { return Whitespace [\t \r\n\f] %quant }
  elseif ( $v1 === \S ) { return Any char except whitespaces [^\t \r\n\f] %quant }
  elseif ( $regex(patttriglit,%token,/^\\Q((?:(?!\\E).)*+)(?:\\E)?$/) ) { return Literal ` $+ $regml(patttriglit,1) $+ ` }
  elseif ( $istokcs(\t [\t] \x09 $chr(9),%token,32) ) { return Tab (ASCII 9) }
  elseif ( $istokcs(\r [\r] \xd \xD \x0d \x0D $cr,%token,32) ) { return Carriage return (ASCII 13) }
  elseif ( $istokcs(\n [\n] \xa \xA \x0a \x0A $lf,%token,32) ) { return Line-feed (newline) (ASCII 10) }
  elseif ( $istokcs(\f [\f] \xc \xC \x0c \x0C $chr(12),%token,32) ) { return Form feed (ASCII 12) }
  elseif ( $istokcs(\a [\a] \x7 \x07 $chr(7),%token,32) ) { return Bell (ASCII 7) }
  elseif ( $istokcs(\e [\e] \x1b \x1B $chr(27),%token,32) ) { return Esc (ASCII 27) }
  elseif ( $istokcs(\x20. .[ ],%token,46) ) { return Space (ASCII 32) }
  elseif ( $istokcs(\xa0 \xA0 $chr(160) \c,%token,32) ) { return Hard Space (ASCII 160) }
  elseif ( $istokcs(\x08 \x8 $chr(8) [\b],%token,32) ) { return BackSpace (ASCII 8) }
  elseif ( $istokcs(\cb \x02 \x2 ,%token,32) ) { return Bold character (ASCII 2) }
  elseif ( $istokcs(\c_ \x1F ,%token,32) ) { return Underline char (ASCII 31) }
  elseif ( $istokcs(\cV \x16 ,%token,32) ) { return Reverse char (ASCII 22) }
  elseif ( $istokcs(\cc \x03 \x3 ,%token,32) ) { return Color code (ASCII 3) }
  elseif ( $istokcs(\co \x0F \xF \xf ,%token,32) ) { return Normal code (ASCII 15) }
  elseif ( $regex(patttriglit,%token,/^\\c(.)$/) ) { return %token %quant Matches Ctrl+ $+ $regml(patttriglit,1) }
  elseif ( $regex(patttriglit,%token,/^(?:\\(?:x[0-9a-zA-Z]{1,2}|[\\"^$|.*+?{}()\[\]\/])|[^^$|.*+?{}()\[\]\\]|\[\\?[\\"^$|.*+?{}()\[\]\/]\])++$/) ) {
    if ( $regex(patttriglit,%token,/(\\([^x])|\[\\?([\\"^$|.*+?{}()\[\]\/])\]|\\x([0-9a-zA-Z]{1,2}))/g) ) {
      %r = $calc($regml(patttriglit,0) - 1)
      var %newchar
      While (%r > 0) {
        if ( $left($regml(patttriglit,%r),2) === \x ) { %newchar = $chr($base($regml(patttriglit,$calc(%r + 1)),16,10)) }
        else { %newchar = $regml(patttriglit,$calc(%r + 1)) }
        %token = $+($left(%token,$calc($regml(patttriglit,%r).pos - 1)),%newchar,$mid(%token,$calc($regml(patttriglit,%r).pos + $len($regml(patttriglit,%r)))))
        dec %r 2
      }
    }
    return Literal ` $+ %token $+ `
  }
}

alias -l regex.Explain.Quantifiers {
  if (!$1) { return }
  var %quant = $1, %possesive = $2, %Umode = $3, %lazy, $false, %from, %to, %inf = infinite, %extra, %extraK = 2
  %lazy = %Umode
  if ( %quant == * ) {
    %from = %inf
    %to = 0
  }
  elseif ( %quant == + ) {
    %from = %inf
    %to = 1
  }
  elseif ( %quant == ? ) {
    %from = 1
    %to = 0
  }
  elseif ( $regex(explainquantif,%quant,/^\{(\d++)(?:(,)(\d++)?)?\}$/) ) {
    %to = $regml(explainquantif,1)
    %from = $iif($regml(explainquantif,3) == $null,%to,$iif($regml(explainquantif,3) == $null,%inf,$v1))
  }
  if ( %possesive == + ) { %extra = %extraK $+ [possesive] }
  elseif ( %possesive == ? ) {
    if ( %lazy ) {
      %lazy = $false
      %extra = %extraK $+ [greedy]
    }
    else {
      %lazy = $true
      %extra = %extraK $+ [lazy]
    }
  }
  if ( %lazy ) {
    %lazy = %to
    %to = %from
    %from = %lazy
  }
  return 14 $+ %from $iif(%to != %from,to %to) times %extra
}
alias -l regex.ExplainModifiers {
  var %target = $1, %modif = $2, %letter, %lvl = $3, %i = 0, %N = $len(%modif), %desc, %on = $true
  While ( %i < %N ) {
    inc %i
    %letter = $mid(%modif,%i,1)
    if ( %letter == - ) {
      %on = $false
      Continue
    }
    elseif ( %letter === g ) { %desc = global. All matches (don't return on first match) }
    elseif ( %letter === i ) {
      if ( %on ) { %desc = insensitive. Case insensitive match (ignores case of [a-zA-Z]) }
      else { %desc = 7-insensitive. Case sensitive match }
    }
    elseif ( %letter === s ) {
      if ( %on ) { %desc = single line. Dot (or negated charclass) matches newline characters }
      else { %desc = 7-single line. A dot (or negated charclass) won't match \n }
    }
    elseif ( %letter === S ) { %desc = Strip. Ignores control codes in text (mIRC only) }
    elseif ( %letter === m ) {
      if ( %on ) { %desc = multi-line. Causes ^ and $ to match the begin/end of each line (not only begin/end of string) }
      else { %desc = 7-multi-line. ^ and $ match not only begin/end of string }
    }
    elseif ( %letter === o ) { %desc = option. This modifier was introduced as a mnemonic rule }
    elseif ( %letter === x ) {
      if ( %on ) { %desc = extended. Spaces and text after a `#` in the pattern are ignored }
      else { %desc = 7-extended. Spaces in pattern are literal spaces }
    }
    elseif ( %letter === X ) {
      if ( %on ) { %desc = eXtra. a \ followed by a letter with no special meaning is faulted }
      else { %desc = 7-eXtra. a \ followed by a letter with no special meaning matches that letter literally }
    }
    elseif ( %letter === A ) { %desc = Anchored. Pattern is forced to ^ }
    elseif ( %letter === U ) {
      if ( %on ) { %desc = Ungreedy. The match becomes lazy by default. Now a ? following a quantifier makes it greedy. }
      else { %desc = 7-Ungreedy. The match becomes greedy by default. }
    }
    else { %desc = no description for it yet. }
    $regex.RefOut(%target,%lvl) %letter $iif(%on,modifier,off) $+ : %desc
  }
}
alias -l regex.match {
  if ($2) {
    noop $regex(re,$2-,/(\/(?>\\.|[^/]*|(?R)*)\/*[gisSmoxXAU]*)/)
    var %p = $regml(re,1), %o = $mid($2-,1,$calc($regml(re,1).pos -1)),%i = 1, %r = 04[14Result:01 $regex(re2,%o,%p) $+ 04]
    while (%i <= $regml(re2,0)) {
      var %r $addtok(%r,$+(04[14,%i,:15,$regml(re2,%i).pos,-,$calc(($regml(re2,%i).pos + $len($regml(re2,%i)) -1)),:01 $regml(re2,%i),04]),32)
      inc %i
    }
    msg $1 $iif($regex(re3,%p,/^\/((?>\\.|[^/])*)\/*[gisSmoxXAU]*$/),%r,Invalid regex!)
  }
  else msg $1 Invalid parameters.
  return 
  :error
  msg $1 Invalid parameters.
  reseterror
}
