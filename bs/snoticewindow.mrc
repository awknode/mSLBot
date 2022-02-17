;;------ Menus ------;;

menu @Network,@Server,@Users,@WallOps,@Whois,@Locops {
  Clear Window:/clear
}

;;------ @Users ------;;
ON *:TEXT:*VERSION*:#noc:  { msg #priv8 08VERSION Reply $2-3 $5- | halt }
ON *:TEXT:*OperServ*:#noc: { msg #priv8 12OperServ: $2- }
ON *:TEXT:*ChanServ*:#noc: { msg #priv8 09ChanServ: $2- }
ON ^*:SNOTICE:*Global*: { msg #priv8 15GLOBAL OPS: $3- | halt }
ON *:TEXT:*NickServ*:#noc: { msg #priv8 12NickServ: $2- $+ . | halt }
ON *:TEXT:*vHostServ*:#noc: { msg #priv8 12vHostServ: $2- $+ . | halt }
ON *:TEXT:*AWAY*:#noc: { msg #priv8 14 $1 $+ : $2  $3- | halt }


ON ^*:SNOTICE:*Client exiting*: { msg #priv8 14(8User14)15 exiting: $4  $+ $5- | halt }
ON ^*:SNOTICE:*Client connect*: { msg #priv8 14(8User14)15 connecting: $4  $+ $5-  | halt }
ON ^*:SNOTICE:*Nick change*: /window -gek @Users | msg #priv8 08NickChange:15 $1- | halt
ON ^*:SNOTICE:*Invalid username*: /window -gek @Users | echo -t @Users 13Invalid:5 $6 7 $7- | halt
ON ^*:SNOTICE:*Global -- from ChanServ*: msg #priv8 2ChanServ: $2-

;;------ @Network/@WallOps/@LocOps ------;;

;;;gline/ungline

ON ^*:SNOTICE:*requesting gline*: msg #priv8 14(8G-Line:Request14) $4 14[ $6 ]7 for 5 $11 7 $12- | halt 
ON ^*:SNOTICE:*triggered gline*: echo -t @Network 13Triggered:3 $4 14[ $6 ]7 for 5 $11 7 $12- | halt

ON ^*:SNOTICE:*Permanent G:Line added*: msg #priv8 14(8G-Line:Added14) $2- | halt
ON ^*:SNOTICE:*removed G:Line*: msg #priv8 14(8G-Line:Removed14) $2- | halt
ON ^*:SNOTICE:*OperOverride*: msg #priv8 09OPER OVERRIDE: $4- | halt
ON ^*:SNOTICE:*Expiring Global Z:Line*: msg #priv8 7EXPIRED GZ:LINE: $2- | halt 
ON *:TEXT:*changed nick to*:#noc: { msg #priv8 07NiCK CHANGE: $2 $+  $3-9 $+  $10-  $+ . | halt }
ON *:TEXT:*blacklist*:#noc: { msg #priv8 12 $1  $2- | halt }

ON *:TEXT:*is*a*(+o)*:#noc: { msg #priv8 15GLOBAL OPS: $1- | halt }
ON *:TEXT:*is*a*(+A)*:#noc: { msg #priv8 15GLOBAL OPS: $1- | halt }
ON *:TEXT:*is*a*(+N)*:#noc: { msg #priv8 15GLOBAL OPS: $1- | halt }
ON *:TEXT:*is*a*(+a)*:#noc: { msg #priv8 15GLOBAL OPS: $1- | halt }
ON *:TEXT:*is*a*(+B)*:#noc: { msg #priv8 15GLOBAL OPS: $1- | halt }
ON ^*:SNOTICE:**** Notice --*: { if (*has changed his/her* iswm $1-) { halt } msg #priv8 5SERVER NOTICE: $4- | halt }

;;;wallops start

on ^*:WALLOPS:*:{
  if (($nick = services.bg) && (*#* iswm $1-)) { msg #priv8 15[10CS15]:7 $1- | haltdef | halt }
  if (($nick = services.bg) && (*#* !iswm $1-)) { msg #priv8 15[10NS15]:7 $1- | haltdef | halt }
  if (($$1 == LOCOPS) || ($$1 == SLOCOPS)) { echo -ts @LocOps 12 $+ 3 $nick  14 $+ $address 7 $2- | halt }
  window -gek @WallOps | echo -t @WallOps 12 $+ 3 $nick 14 $+ $address 7 $1- | halt
}

on *:INPUT:@Locops: /locops $1-
on *:INPUT:@WallOps: /operwall : $+ $1-


;=====Highlight on WallOps========
on *:wallops:$(* $+ $me $+ *): {
  if ($$1 = LOCOPS) { window -g2 @LocOps }
  else { /window -g2 @WallOps }
}
;===================================


;;;kill messages

;; ON ^*:SNOTICE:*Received KILL message*: msg #priv8 14(8Kill14) $2- | halt

;;;kline/unkline

ON ^*:SNOTICE:*KLine active for*: /window -gek @Network | echo -t @Network 5Kline set:15 $7 7 $8- | halt

ON ^*:SNOTICE:*G:Line added*: /window -gek @Network | msg #opers 3G-Line active:15 $1- | halt
ON ^*:SNOTICE:*removed G:Line*: /window -gek @Server | msg #opers 3G-Line removed:15 $1- | halt

;;------ @Whois/Operspy notices ------;;

ON ^*:SNOTICE:*did a /whois on you*: /window -gek @Whois | msg #priv8 14(8Whois14) I have been whois'd. $2-3 | halt
ON ^*:SNOTICE:*OPERSPY*: /window -gek @Whois | echo -t @Whois 15Operspy:5 $5  $+ 15 $6 15 $7- | halt

;;------ @Server ------;;

ON ^*:SNOTICE:*is now an IRC operator*: /window -gek @Server | echo -t @Server 3Oper connected:15 $4 14 $5 | msg #priv8 14(08Oper Up14) $1- | halt
ON ^*:SNOTICE:*Failed OPER attempt*: /window -gek @Server | echo -t @Server 3Oper failed:15 $8 14 $9- | msg #priv8 14(08Oper Fail14) $1- | halt
ON ^*:SNOTICE:*LINK*: /window -gek @Server | echo -t @Server 3Link request:7 $5 15 $8 0 $9- | msg #priv8 [7Link Request]:15 $1- | halt
ON ^*:SNOTICE:*STATS*: msg #priv8 14(8Stats14) $2- | halt
ON ^*:SNOTICE:*ADMIN requested*: /window -gek @Server | echo -t @Server 3ADMIN request:15 $7 7 $8- | halt
ON ^*:SNOTICE:*motd requested*: /window -gek @Server | echo -t @Server 3MOTD request:15 $7 7 $8- | halt
ON ^*:SNOTICE:*info requested*: /window -gek @Server | echo -t @Server 3Info:5 $7 7 $8- | halt
ON ^*:SNOTICE:*is rehashing server config*: /window -gek @Server | echo -t @Server 3Rehash:15 $4 7 | msg #priv8 14(Rehash14) $2- 7 | halt
ON ^*:SNOTICE:*is clearing G-lines*: /window -gek @Server | echo -t @Server 3G-lines cleared:15 $4 7 | halt
ON ^*:SNOTICE:*trace requested*: /window -gek @Server | echo -t @Server 3Trace request:15 $7 7 $8- | halt
ON ^*:SNOTICE:*Netsplit*: /window -gek @Server | echo -t @Server 15Split:5 $5 7from3 $8- | msg #priv8 14(8Netsplit14) $2- | halt
ON ^*:SNOTICE:*Server*being*introduced*by*: /window -gek @Server | echo -t @Server 3Connect:5 $5 7 to 3 $9 7 $10- | halt
