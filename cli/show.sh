#!/usr/bin/env bash

function title(){
	echo
	ScreenLen=$(stty size |awk '{print $2}')
	TitleLen=$(echo -n $1 |wc -c)
	LineLen=$(((${ScreenLen} - ${TitleLen})   ))
	
	echo -en "\033[96m$1\033[0m" && yes "*" |sed ''''${LineLen}'''q' |tr -d "\n" && echo
	echo
	
}


function text(){
    if [ $2 ]
    then
        printf "\033[32m%s\033[0m\n" "$1"
    else
    	printf "%-100s" "$1"
    fi 
}

function setlogfile(){
	curtime=$(date "+%Y-%m-%d-%H_%M_%S")
	mkdir -p $(pwd)/log
	export logfile=$(pwd)/log/$curtime
}
