#.bash_functions

## Include Others Functions
for i in $(echo "file netw mgmt misc");do
    [[ -s .bash_functions_$i ]]&& . .bash_functions_$i
done

## Wait for PID
function waitForPid(){ 
    #if [[ ! -z $1 && ! -z $2 ]];then
        [[ ! $1 =~ ^[0-9]+$ ]]&& PROC=$(pidof $1) || PROC=$1
        PHRASE=$2
        clear
        while [[ $(ps -ef | awk '{ print $2}' |grep "$PROC" ) ]];do
                echo -en " $PHRASE /\033[1G" ; sleep .07
                echo -en " $PHRASE -\033[1G" ; sleep .07
                echo -en " $PHRASE \ \033[1G" ; sleep .07
                echo -en " $PHRASE |\033[1G" ; sleep .07
        done;
        clear    
    #fi
}

## Hook halt/reboot in ssh
#function halt(){
#	if [[ -z `ps -p $PPID | grep ssh` ]];then
#		/sbin/shutdown -h now;
#	else
#		echo -e "\n\r\n\r ### WARNING ## \n\rTo prevent errors, 'halt' command used into an SSH session is disabled \n\r\n\r";
#	fi
#}

#function reboot(){
#	if [[ -z `ps -p $PPID | grep ssh` ]];then
#		/sbin/shutdown -r now;
#	else
#		echo -e "\n\r\n\r ### WARNING ## \n\rHostname: `hostname` \n\r"
#		echo -e " To prevent errors, 'reboot' command used into an SSH session is disabled \r\n"
#		echo -e " (If you are really sure you want to reboot, please use the command: 'shutdown' ) \n\r\n\r"
#	fi
#}

## Search in the set env 
function searchenv(){ 
    [[ ! -z $* ]]&& env | grep "$*"; 
}

## Basic calc
function calc(){ 
    [[ -z $* ]]&& bc || echo "$*" | bc;
}
#
