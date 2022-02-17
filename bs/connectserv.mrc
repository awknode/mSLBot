on *:load:{ 
  set %logchannel $$?="Choose log channel"
  set %defserv $$?="Choose default server"
  echo -a Log Channel Set To: %logchannel
  echo -a Default Server Set To: %defserv
  echo -a REMEMBER: give the bot these snomasks: +cfFkvGnNsoS
}

on *^:snotice:{
  if ($server == %defserv) {
    ;CHG commands
    if (changed the virtual hostname isin $1-) {  msg %logchannel 10CHG:15 $1 14used /chghost on15 $7 14-=-15 $11  }
    if (changed the virtual ident isin $1-) {  msg %logchannel 10CHG:15 $1 14used /chgident on15 $7 14-=-15 $11  }
    if (changed the GECOS isin $1-) {  msg %logchannel 10CHG:15 $1 14used /chgname on15 $4 14-=-15 $10  }

    ;Nick Changes
    if (has changed his/her nickname to isin $1-) {  msg #priv8 10Nick Change:15 $4 14-=-15  $11  }

    ;Connections
    if (Client connecting on isin $1-) { 
      msg #priv8 3Connection:15 $server 14-=-15 $9 $10
      ctcp $9 version 
    }
    if (exiting: == $1-) { msg #priv8 15Disconnection:15 $server 14-=-15 $6 $7 }
    if (Client connecting at isin $1-) {
      msg #priv8 3Connection:15 $7 14-=-15 $8 $9
      ctcp version $8 version
    }
    if (exiting == $1-) { msg #priv8 15Disconnection:15 $7 14-=-15 $8 }

    ;Opers
    if (is now a network administrator isin $1-) { msg %logchannel 10Oper:15 $1 14is now a network admin 11(N) }
    if (is now a services administrator isin $1-) { msg %logchannel 10Oper:15 $1 14is a services admin 11(a) }
    if (is now a server admin isin $1-) { msg %logchannel 10Oper:15 $1 14is a server admin 11(A) }
    if (is now a co administrator isin $1-) { msg %logchannel 10Oper:15 $1 14is a co admin 11(C) }
    if (is now an operator isin $1-) { msg %logchannel 10Oper:15 $1 14is global operator 11(O) }
    if (is now a local operator isin $1-) { msg %logchannel 10Oper:15 $1 14is local operator 11(o) }
    if (Failed OPER attempt isin $1-) && ([unknown oper] isin $1-) { msg %logchannel 10Oper: 14Failed oper attempt:15 $5 14-=-15 $7- }
    if (Failed OPER attempt isin $1-) && ([FAILEDAUTH] isin $1-) { msg %logchannel 10Oper: 14Failed oper attempt by15 $5 14using ID of15 $9 } 
    if (OperOverride isin $1-) { msg #priv8 08Oper Override: $1- }

    ;Servers
    if (Link == $4) && (is now synced isin $8-) { msg %logchannel 7Server15: $5 14is now linked to15 $7 }
    if (Link denied for isin $1-) { msg %logchannel 7Server: 14Link denied for15 $7 | msg %logchannel 7-=-15 $8 $9 $10 $11 $12 $13 $14 $15 $16 | msg %logchannel 7-=-15 $17 }
    if (Lost connection to isin $1-) { msg %logchannel 7Server:14 lost connection to15 $4 }
    if (LocOps -- Received SQUIT isin $1-) { msg %logchannel 7Server:15 $6 7-=- 14SQUIT by15 $8 }
    if (Received SQUIT isin $1-) && (Global isin $1-) { msg %logchannel 7Server:15 $8 7-=- 14SQUIT by15 $10 }

    ;Kill \ Kline \ Zline \ Gline \ Spamfilter add|del|match spam filter \ shun
    if (received kill message isin $1-) { .timer 1 1 msg %logchannel 10Oper:14 Kill for15 $8 10-=-14 from15 $10 }
    if (Permanent G:Line added isin $1-) { .timer 1 1 msg %logchannel 10Oper:14 Gline added for15 $6 10-=-15 $14 $15 14 $16- 15) }
    if (removed G:line isin $1-) { msg %logchannel 10Oper:14 Gline for15 $4 14has been removed by15 $1 15) }
    if (Permanent Shun added for isin $1-) { msg %logchannel 10Oper:14 Shun added for15 $6 19-=-15 $14 $15 14 $16- 15) }
    if (removed Shun isin $1-) { msg %logchannel 10Oper:14 Shun for15 $4 14has been removed by15 $1 15) }
    if (Spamfilter Added: isin $1-) { msg %logchannel 10Oper:14 Spamfilter added for:15 $4 10-=-14 added by15 $18 $19 }
    if (removed Spamfilter isin $1-) { msg %logchannel 10Oper:14 Spamfilter for:15 $4 10-=-14 has been removed by15 $1 } 
    if ([Spamfilter] isin $1-) && ( matches filter isin $1-) { echo @snotice 10Oper:14 $2 10-=-Met the spamfilter for:15 $6 10-=- at $fulldate }
    if (Permanent K:Line added isin $1-) { .timer 1 1 msg %logchannel 10Oper:14 Kline added for:15 $6 10-=-14 added by15 $14 $15 14 $16- 15) }
    if (removed K:line isin $1-) { msg %logchannel 10Oper:14 Kline for:15 $4 14has been removed by15 $1 15) }
    if (Permanent Z:Line added isin $1-) { .timer 1 1 msg %logchannel 10Oper:14 Zline added for:15 $6 10-=-14 added by15 $14 $15 14 $16- 15) }
    if (removed Z:line isin $1-) { msg %logchannel 10Oper:14 Zline for:15 $4 14has been removed by15 $1 15) }
  }
}

on *:CTCPREPLY:VERSION*:/msg %logchannel 3Connection:15 $nick 14is using IRC client:15 $1-
