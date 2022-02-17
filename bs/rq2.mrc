On $*:text:/^[!%.@]r(|equest)(\s|$)/Si:#batcave-chat: { 
  spamprotect 
  exprotect $1-
  if ($2 == list) { msg #batcave-chat %items | halt }
  if ($2-) {
    msg s-c-o-o-t $+([12,$nick,]) has made a 12request for the file: [12  $2- ] Your help would be greatly appreciated by this young man. Thanks. 
    msg BatmanHush $+([12,$nick,]) has made a 12request for the file: [12 $2- ] Your help would be greatly appreciated by this young man. Thanks. 
    msg skeptical $+([12,$nick,]) has made a 12request for the file: [12 $2- ] Your help would be greatly appreciated by this young man. Thanks. 
    msg #batcave-chat [12REQUST] to be 12filled for the file: [12  $2- ] Thanks for the 12request, an admin will add this for you soon. You're in great hands at Batcave :).
  } 
}

On $owner:text:/^[!%.@]fill(|ed)(\s|$)/Si:#batcave-chat: { 
  spamprotect 
  exprotect $1-
  if (!$2) { msg # Improper syntax. [Ex: !12filled <file> ] | haltdef } 
  if ($2-) { msg s-c-o-o-t has 12filled a 12request for the file: [12  $2- ] Thanks for being a great admin.. 
    msg Batmanhush has 12filled a 12request for the file: [12  $2- ] Thanks for being a great admin.
    msg skeptical has 12filled a 12request for the file: [12  $2- ] Thanks for being a great admin.
    msg #batcave-chat [12FILLED] 12request for the file: [12  $2- ] Thanks for being a great admin.
  }
} 
