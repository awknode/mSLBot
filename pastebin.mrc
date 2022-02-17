;----------------------------------------------------------------------
; Author      : bruas aka biase @ Webchat & DalNet, Lite @ KampungChat
; Name        : A simple pastebin.com info
; URL         : -
; Description : A simple non-socket pastebin info, created using $com for socket haters.
;             : It will trigger when a user paste a pastebin.com url with or whitout 'http://'.
; Setting     : -
;----------------------------------------------------------------------

on *:text:*:#: pastebin_info $1-
alias pastebin_info {
  if ($regex($1-, /^(?:.*?\s)?(?:https?:\/\/)?(?:www\.)?pastebin.com(?:\/(u))?\/(\w+)\/?(?:\s.*)?$/Si)) {
    var %jscript $&
      var xmlhttp = new ActiveXObject("MSXML2.XMLHTTP.6.0"); $crlf $&
      xmlhttp.open("GET", "http://pastebin.com/ $+ $regml(1) $+ ", false); xmlhttp.send(); $crlf $&
      TITLE = xmlhttp.responseText.match("<div class=\"paste_box_line1\" title=\"(.+)\">", "i")[1]; $crlf $&
      ON = xmlhttp.responseText.match("<img src=\"\/i\/t\.gif\" class=\"img_line t_da\" alt=\"\"> <span title=\".+\">(.+)</span>", "i")[1]; $crlf $&
      BY = xmlhttp.responseText.match("<img src=\"\/i\/t\.gif\" class=\"img_line t_us\" alt=\"\" style=\"margin-left:0\"> (.+)", "i")[1]; $crlf $&
      VIEWS = xmlhttp.responseText.match("title=\"Unique visits to this paste\"> (.+)", "i")[1]; $crlf $&
      SYNTAX = xmlhttp.responseText.match("<a href=\"\/archive\/mirc\" class=\"buttonsm\" style=\"margin:0\">(.+)<\/a>", "i")[1]; $crlf $&  
      SIZE = xmlhttp.responseText.match("mIRC<\/a><\/span> (.+)", "i")[1]; $crlf $&
      EXP = xmlhttp.responseText.match("title=\"When this paste gets automatically deleted\"> (.+)", "i")[1];

    :initialization
    var %jscriptobj $+(jscript,$ticks), %result
    if ($com(%vbscriptobj)) goto initialization

    .comopen %jscriptobj msscriptcontrol.scriptcontrol
    if ($comerr) return
    noop $com(%jscriptobj,language,5,bstr,jscript) $com(%jscriptobj,executestatement,3,bstr,%jscript)

    var %title $null($com(%jscriptobj,eval,3,bstr,TITLE)) $com(%jscriptobj).result
    if (!%title) echo -i27 # $str($chr(160),26) [12Pastebin] That paste is gone bro.
    else {
      msg # [12Pastebin] %title $chr(5) $&
        By: $null($com(%jscriptobj,eval,3,bstr,BY)) $com(%jscriptobj).result $chr(5) $&
        On: $gettok($null($com(%jscriptobj,eval,3,bstr,ON)) $com(%jscriptobj).result,1-5,32) $chr(5) $&
        Syntax: $null($com(%jscriptobj,eval,3,bstr,SYNTAX)) $com(%jscriptobj).result $chr(5) $&
        Size: $null($com(%jscriptobj,eval,3,bstr,SIZE)) $com(%jscriptobj).result $chr(5) $&
        Views: $null($com(%jscriptobj,eval,3,bstr,VIEWS)) $com(%jscriptobj).result $chr(5) $&
        Expires: $null($com(%jscriptobj,eval,3,bstr,EXP)) $com(%jscriptobj).result
      .comclose %jscriptobj
    }
  }
}
