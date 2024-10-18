#!/bin/sh

#dateformat='+%a %d-%m-%y %T'
#dateformat="+%d-%m-%y"        #31-12-99
#dateformat="+%a"              #dag
dateformat="+%H:%M"           #12:34
#dateformat="+%T"              #12:34:56

dwm_date () {
datenow=$(date +%H:%M:%S)

hour=$(echo $datenow | cut -d ":" -f1)
min=$(echo $datenow | cut -d ":" -f2)
second=$(echo $datenow | cut -d ":" -f3)

sec2=$(($second + 10))
sec3=$(($sec2 % 2))
divider=':'
#fuzzymin='err'
#if [[ $min < 5 ]] ; then 
#	fuzzymin='sharp     |' 	
#elif [[ $min < 20 ]]; then 
#	fuzzymin='fifteen   |'
#elif [[ $min < 40 ]]; then 
#	fuzzymin='thirty    |'
#elif [[ $min < 55 ]]; then 
#		fuzzymin='fortyfive |'
#elif [[ $min < 65 ]]; then 
#		fuzzymin="sharp($min)|"
#fi


if [[ $sec3 == 1 ]];then divider=' '; fi
    printf "%s" "$SEP1"
    if [ "$IDENTIFIER" = "unicode" ]; then
        printf "📆 %s"  #"$timenow"
    else
        #printf "%s" "$timenow"
        #printf "%s" $(date "$dateformat")
	printf "%s%s%s" "$hour" "$divider" "$min" #"$fuzzymin"
    fi
    printf "%s\n" "$SEP2"
}

#fuzzyMinute() {
#if [[ $1 < 5 ]] ; then return 'sharp     |'; fi
#if [[ $1 < 20 ]]; then return 'fifteen   |'; fi
##if [[ $1 < 30 ]]; then return 'twenty    |'; fi
#if [[ $1 < 40 ]]; then return 'thirty    |'; fi
##if [[ $1 < 40 ]]; then return 'forty     |'; fi
##if [[ $1 < 45 ]]; then return 'fortyfive |'; fi
#if [[ $1 < 55 ]]; then return 'fortyfive |'; fi
#if [[ $1 > 55 ]]; then return 'sharp     |'; fi

#}

dwm_date
