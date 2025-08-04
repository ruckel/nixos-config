#/bin/sh

TOPIC=korvintihi
TITLE=körb
PRIORITY=2
TAGS=hotdog   #poop,tada
CLICK=     #https://home.nest.com/
ATTACH=    #https://nest.com/view/yAxkasd.jpg
ACTIONS=   #http, Open door, https://api.nest.com/open/yAxkasd, clear=true
EMAIL=
MD=
DELAY=  #delay/in/at

MSG=bajsk
MSG=$@ 

compose (){
                        printf -- "ntfy.sh/$TOPIC "
if [ $TITLE ];     then printf -- "-H \"Title: $TITLE\" "; fi
if [ $PRIORITY ];  then printf -- "-H \"Priority: $PRIORITY\" "; fi
if [ $TAGS ];      then printf -- "-H \"Tags: $TAGS\" "; fi
if [ $CLICK ];     then printf -- "-H \"Click: $CLICK\" "; fi
if [ $ATTACH ];    then printf -- "-H \"Attach: $ATTACH\" "; fi
if [ $ACTIONS ];   then printf -- "-H \"Actions: $ACTIONS\" "; fi
if [ $EMAIL ];     then printf -- "-H \"Email: $EMAIL\" " ; fi
if [ $DELAY ];     then printf -- "-H \"Email: $DELAY\" " ; fi
if [ $MD ];        then printf -- "-H \"Markdown: yes\" "; fi
printf -- "-d \"%s\"" "$MSG"
}
compose | xargs curl
