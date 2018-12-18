#!/bin/bash
# Maintainer AnilKumar Patel

# install environment variables.
install_files()
{
echo ""
echo -e "\033[0;31m _________ \033[0m _   _\033[0;31m  ______ \033[0m_______\033[0;31m     ___      \033[0m _      \033[0m _     "
echo -e "\033[0;31m|___  ____|\033[0m| \ | |\033[0;31m|  ____|\033[0m__   __\033[0;31m    /   \     \033[0m| |     \033[0m| |    "
echo -e "\033[0;31m    | |    \033[0m|  \| |\033[0;31m| |____ \033[0m  | |  \033[0;31m   /  -  \    \033[0m| |     \033[0m| |    "
echo -e "\033[0;31m    | |    \033[0m|   | |\033[0;31m|____  |\033[0m  | |  \033[0;31m  /  / \  \   \033[0m| |     \033[0m| |    "
echo -e "\033[0;31m ___| |___ \033[0m| |\  |\033[0;31m ____| |\033[0m  | |  \033[0;31m /  /---\  \  \033[0m| |____ \033[0m| |___ "
echo -e "\033[0;31m|_________|\033[0m|_| \_|\033[0;31m|______|\033[0m  |_|  \033[0;31m/__/     \__\ \033[0m|______|\033[0m|_____|"
echo ""
sleep 0

install_location=$(sudo find / -iname '*zc_install*' 2>/dev/null| grep -E -i '/zc_install$' | wc -l)
if [ $install_location -gt 1 ]; then
install_home=$(pwd)
else
install_home=$(sudo find / -iname '*zc_install*' 2>/dev/null | grep -E -i '/zc_install$')
fi
install_conf=$install_home/conf/install.conf
log_conf=$install_home/conf/log.conf
install_packages=$install_home/packages
install_registry=$install_home/Registry
install_logs=$install_home/logs
install_conf=$install_home/conf
pid_conf=$install_home/.install.pid
install_agent=$install_home/conf/install.yml
log_conf_dir=$(dirname "${log_conf}")
if [ ! -f $log_conf ];then
	echo -e "\033[0;31mPlease create file \e[1mlog.conf\033[0m \033[0;31mat location\033[0m: $log_conf_dir"
	echo ""
	exit 1
fi
[ -f $install_conf ] || touch $install_conf
[ -f $log_conf ] || touch $log_conf
[ -f $install_agent ] || touch $install_agent
[ -f $pid_conf ] || touch $pid_conf
[ -d $install_packages ] || mkdir $install_packages
[ -d $install_registry ] || mkdir $install_registry
[ -d $install_logs ] || mkdir $install_logs
> $pid_conf
> $install_conf
}

# Sanity checks are run-time tests that protect the script from running in unsuitable environments.
senity_check()
{
echo ""
echo "Starting sanity checking."
echo ""

hostname="$(whoami)"
echo -e "hostname: ${hostname}"
echo ""
sleep 2

echo -e "[hostname]" >> $install_conf
echo -e "$hostname" "\n" >> $install_conf

cpu_details="$(grep processor /proc/cpuinfo | wc -l)"
if [ "${cpu_details}" -eq "0" ] ; then
    echo -e "\033[0;31mPlease increase the \e[1mcpu!\e[0m. \033[0m" >&2
    echo ""
    exit 1
fi
echo -e "cpu-count: ${cpu_details}"
echo ""
sleep 2

echo -e "cpu-load: $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage "%"}')"
echo ""
sleep 2

echo -e "[cpu_count]" >> $install_conf
echo -e "$cpu_details" "\n" >> $install_conf

free_memory="$(free -m | grep Mem | awk '{print $7}')"
echo "free-mem: ${free_memory}MB"
echo ""
sleep 2

if [ "${free_memory}" -lt "1024" ] ; then
    echo -e "\033[0;31mPlease increase the \e[1mmemory\e[0m!\033[0m" >&2
    echo ""
    exit 1
fi

echo -e "$(free -m | awk 'NR==2{printf "mem-Usage: %sMB/%sMB (%.2f%%)\n", $3,$2,$3*100/$2 }')"
echo ""
sleep 2

echo -e "$(df -h | awk '$NF=="/"{printf "disk-usage: %dGB/%dGB (%s)\n", $3,$2,$5}')"
echo ""
sleep 2

echo -e "[free_mem]" >> $install_conf
echo -e "$free_memory" "\n" >> $install_conf

free_space="$(df -Ph  |awk '{if($6 == "/") print $4}')"
echo "free-space: ${free_space}"
echo ""
sleep 2

echo -e "[free_space]" >> $install_conf
echo -e "$free_space" "\n" >> $install_conf

os_architecture="$(uname -m)"
echo -e "[os]" >> $install_conf
echo -e "$os_architecture" "\n" >> $install_conf

echo "os: ${os_architecture}"
echo ""
sleep 2
}

# check prerequisite for install i.e curl, wget and filebeat are installed or not depend upon os.
verifying_prerequisite()
{
if [ "$1" = "CentOS" ]; then
	if ! [ -f $install_packages/install-agent ] > /dev/null 2>&1 ; then
		read -p "install agent not found! Do you want to install press (y/n) : " result
   		echo ""
   		if [ "$result" = "y" ]; then
		echo -e "\033[0;31mPlease wait while agent is installing...\033[0m"
                echo ""
		    if ! which curl > /dev/null 2>&1 ; then
			read -p "curl not found! Do you want to install curl press (y/n) : " result
   			echo ""
   			if [ "$result" = "y" ]; then
				echo -e "\033[0;31mPlease wait while curl is installing...\033[0m"
                		echo ""
   				sudo yum install curl -y > /dev/null 2>&1
   			fi
			if [ "$result" = "n" ]; then
     				echo -e "\033[0;31mPlease install the curl by using below command and again run the install script.\033[0m"
				echo ""
   				echo -e "sudo yum install curl -y"
				echo ""
     				exit 1
   			fi
		    fi
			curl -k -o $install_packages/install-agent "https://lab.formcept.com/apps/install/install-agent" > /dev/null 2>&1
			sudo chmod 755 $install_packages/install-agent > /dev/null 2>&1
   		fi
		if [ "$result" = "n" ]; then
     			echo -e "\033[0;31mPlease again run the install script.\033[0m"
			echo ""
     			exit 1
   		fi
	fi
fi
if [ "$1" == "Ubuntu" ]; then
        ubuntu_version="$(lsb_release -r | awk '{print $2}')"
	echo "ubuntu_version: ${ubuntu_version}"
	echo ""
	sleep 2
	echo -e "[ubuntu_version]" >> $install_conf
	echo -e "$ubuntu_version" "\n" >> $install_conf
        ubuntu_codename="$(lsb_release --codename | cut -f2)"
        echo "ubuntu_codename: ${ubuntu_codename}"
        echo ""
        sleep 2
        echo -e "[ubuntu_codename]" >> $install_conf
        echo -e "$ubuntu_codename" "\n" >> $install_conf

	if ! [ -f $install_packages/install-agent ] > /dev/null 2>&1 ; then
		read -p "install agent not found! Do you want to install press (y/n) : " result
   		echo ""
   		if [ "$result" = "y" ]; then
                	echo -e "\033[0;31mPlease wait while agent is installing...\033[0m"
                	echo ""
			 if ! which wget > /dev/null 2>&1 ; then
			 	read -p "wget not found! Do you want to install wget press (y/n) : " result
			 	echo ""
   					if [ "$result" = "y" ]; then
                				echo -e "\033[0;31mPlease wait while wget is installing...\033[0m"
                				echo ""
   						sudo apt-get install wget -y > /dev/null 2>&1
   					fi
					if [ "$result" = "n" ]; then
     						echo -e "\033[0;31mPlease install the wget by using below command and again run the install script.\033[0m"
						echo ""
   						echo -e "sudo apt-get install wget -y"
                        			echo ""
     						exit 1
   					fi
			fi
			 wget --no-check-certificate https://lab.formcept.com/apps/install/install-agent -P $install_packages > /dev/null 2>&1
			 sudo chmod 775 $install_packages/install-agent > /dev/null 2>&1
   		fi
		        if [ "$result" = "n" ]; then
                        echo -e "\033[0;31mPlease again run the install script.\033[0m"
                        echo ""
                        exit 1
                	fi
	fi
fi
}

install_file()
{
count=0
while IFS= read -r var
do
 if [ "$var" != "" ]; then
        log_conf[$count]="$var"
        count=$(($count+1))
 fi
done < "$log_conf"
inc=0
count=0
while [ $inc -lt ${#log_conf[*]} ]
do
if [[ ${log_conf[$inc]} =~ [\[].*[\]] ]];then
     if [ $inc -ne 0 ];then echo -e "" >> $install_conf;fi
        echo -e "${log_conf[$inc]}" >> $install_conf
        var1="$(echo "${log_conf[$inc]}" | tr -d '[]')"
         tag[$count]="$var1"
         count=$(($count+1))
else
     ls -1 ${log_conf[$inc]} > /dev/null 2>&1
     if [ "$?" != "0" ]; then
                echo -e "\033[0;31mfile not found at location\033[0m: ${log_conf[$inc]}"
		echo ""
                exit 1
     fi
        for file in $(sudo find / -path "${log_conf[$inc]}" 2>/dev/null | grep -v '\.tar.gz$'); do
                if [ -f "$file" ];then
                       echo -e "$file" >> $install_conf
                else
                      echo -e "\033[0;31mfile not found at location\033[0m: ${log_conf[$inc]}"
		      echo ""
		      exit 1
                fi
        done
fi
inc=$(($inc+1))
done
}

# creating individual array for different logs that are fetched from log.conf file.
install_array()
{
count=0
while IFS= read -r var
do
 if [ "$var" != "" ]; then
        log_path[$count]="$var"
        count=$(($count+1))
 fi
done < "$install_conf"

i=0
while [ $i -lt ${#log_path[@]} ]
do
if [[ ${log_path[$i]} =~ [\[].*[\]] ]];then
         var1="$(echo "${log_path[$i]}" | tr -d '[]')"
         count=0
fi
if [[ ! ${log_path[$i]} =~ [\[].*[\]] ]];then
        eval $var1[$count]="${log_path[$i]}"
        count=$(($count+1))
fi
i=$(($i+1))
done
}

install_agent()
{
> $install_agent

echo -e "[SERVICE]" >> $install_agent
echo -e "    Flush        5" >> $install_agent
echo -e "    Daemon       Off" >> $install_agent
echo -e "    Log_Level    info" >> $install_agent
echo -e "    Parsers_File parsers.conf" >> $install_agent
echo -e "    Plugins_File plugins.conf" >> $install_agent
echo -e "    HTTP_Server  Off" >> $install_agent
echo -e "    HTTP_Listen  0.0.0.0" >> $install_agent
echo -e "    HTTP_Port    2020" >> $install_agent
echo -e "\n" >> $install_agent

for tag_array in ${tag[@]}
do
  count=0
    tmp="${tag_array}[@]"
    last_element="${tag_array}[-1]"
    for log_file_array in "${!tmp}"
     do
         echo -e "[INPUT]" >> $install_agent
         echo -e "    Name        tail" >> $install_agent
         echo -e "    Path        $log_file_array" >> $install_agent
         echo -e "    Tag  $tag_array" >> $install_agent
         echo -e "    Exclude_Path *.gz,*.xz" >> $install_agent
         echo -e "    DB                $install_home/Registry/$(basename $log_file_array)" >> $install_agent
         echo -e "    Mem_Buf_Limit     1MB" >> $install_agent
         echo -e "    Refresh_Interval  10" >> $install_agent
         echo -e "    Buffer_Chunk_Size 1MB" >> $install_agent
         echo -e "    Buffer_Max_Size   1MB" >> $install_agent
         echo -e "\n" >> $install_agent

        count=$(($count+1))
        if [ "$log_file_array" = "${!last_element}" ];then
		echo -e "[FILTER]" >> $install_agent
		echo -e	"    Name   modify" >> $install_agent
                echo -e "    Match  $tag_array" >> $install_agent
		echo -e "    Add_if_not_present  log_type  $tag_array" >> $install_agent
		echo -e "\n" >> $install_agent
                echo -e "[OUTPUT]" >> $install_agent
                echo -e "    Name   kafka" >> $install_agent
                echo -e "    Match  $tag_array" >> $install_agent
                echo -e "    Brokers   192.168.86.36" >> $install_agent
                echo -e "    Format   json" >> $install_agent
                echo -e "    Topics   $tag_array" >> $install_agent
                echo "" >> $install_agent
        fi
     done
done

         echo -e "[INPUT]" >> $install_agent
         echo -e "    Name cpu" >> $install_agent
         echo -e "    Tag  cpu_usage" >> $install_agent
         echo -e "\n" >> $install_agent
         echo -e "[OUTPUT]" >> $install_agent
         echo -e "    Name   kafka" >> $install_agent
         echo -e "    Match  cpu_usage" >> $install_agent
         echo -e "    Brokers   192.168.86.36" >> $install_agent
         echo -e "    Format   json" >> $install_agent
         echo -e "    Topics   cpu_usage" >> $install_agent
         echo "" >> $install_agent
         echo -e "[INPUT]" >> $install_agent
         echo -e "    Name          disk" >> $install_agent
         echo -e "    Tag           disk_usage" >> $install_agent
         echo -e "    Interval_Sec  1" >> $install_agent
         echo -e "    Interval_NSec 0" >> $install_agent
         echo -e "\n" >> $install_agent
         echo -e "[OUTPUT]" >> $install_agent
         echo -e "    Name   kafka" >> $install_agent
         echo -e "    Match  disk_usage" >> $install_agent
         echo -e "    Brokers   192.168.86.36" >> $install_agent
         echo -e "    Format   json" >> $install_agent
         echo -e "    Topics   disk_usage" >> $install_agent
         echo "" >> $install_agent
         echo -e "[INPUT]" >> $install_agent
         echo -e "    Name   kmsg" >> $install_agent
         echo -e "    Tag    kernel_msg" >> $install_agent
         echo -e "\n" >> $install_agent
         echo -e "[OUTPUT]" >> $install_agent
         echo -e "    Name   kafka" >> $install_agent
         echo -e "    Match  kernel_msg" >> $install_agent
         echo -e "    Brokers   192.168.86.36" >> $install_agent
         echo -e "    Format   json" >> $install_agent
         echo -e "    Topics   kernel_msg" >> $install_agent
         echo "" >> $install_agent
         echo -e "[INPUT]" >> $install_agent
         echo -e "    Name   mem" >> $install_agent
         echo -e "    Tag    memory_usage" >> $install_agent
         echo -e "\n" >> $install_agent
         echo -e "[OUTPUT]" >> $install_agent
         echo -e "    Name   kafka" >> $install_agent
         echo -e "    Match  memory_usage" >> $install_agent
         echo -e "    Brokers   192.168.86.36" >> $install_agent
         echo -e "    Format   json" >> $install_agent
         echo -e "    Topics   memory_usage" >> $install_agent
         echo "" >> $install_agent
}

install_record_count()
{
echo -e "\033[0;31mplease wait while the log records are being fetched ...\033[0m"
total=0
count=0
for tag_array in ${tag[@]}
do
#  count=0
    tmp="${tag_array}[@]"
    for log_file_array in "${!tmp}"
     do
       if [ $count -eq 0 ];then
		echo "" 
		echo -e "\033[0;31m$tag_array location and no of records fetched\033[0m"
		echo ""
       fi
        	NUMOFLINES=$(sudo cat -u $log_file_array 2>/dev/null | wc -l )
        	echo -e "\033[0;34m$log_file_array\033[0m: \033[0;32m$NUMOFLINES\033[0m"
        	let "total += NUMOFLINES"
                count=$(($count+1))
     done
done
echo ""
echo -e "total no of log records search: $total"
echo ""

if [ $count -eq 0 ];then
echo -e "\033[0;31mplease insert log file location in log.conf file at location\033[0m: $log_conf_dir"
echo ""
fi 
}

function install_service()
{
install_files
ps aux | grep install.sh | egrep -v "grep|Helper" | awk '{print $2}' >> $pid_conf
nohup $install_home/init.sh 2> /dev/null &
senity_check
verifying_prerequisite $distro_type
install_file
install_array
install_agent
install_record_count
kill -9 $(ps aux | grep init.sh | egrep -v "grep|Helper" | awk '{print $2}') 2>/dev/null
}

if [ ! -z $1 ];then
	if [ "$1" == "start" ]
	then
		install_pid=$(ps aux | grep install-agent | egrep -v "grep|Helper" | awk '{print $2}') > /dev/null 2>&1
		if [ -z "$install_pid" ];then
			distro_type=`sed -n -e '/PRETTY_NAME/ s/^.*=\|"\| .*//gp' /etc/os-release`
			install_service
			nohup $install_home/packages/install-agent -c $install_home/conf/install.yml >> $install_home/logs/install.$(date +%Y-%m-%d_%H:%M).log 2> /dev/null &
			echo -e "install Agent started"
			echo ""
		else
			echo -e ""
			echo -e "Starting install ... already running as process $install_pid ."
			echo -e ""
		fi
	elif [ "$1" == "stop" ]
	then
		sudo pkill -f install-agent 2>&1 &
		echo ""
		echo -e "\033[0;31minstall agent stopped!\033[0m"
		echo ""
	elif [ "$1" == "status" ]
	then
		install_pid=$(ps aux | grep install-agent | egrep -v "grep|Helper" | awk '{print $2}') > /dev/null 2>&1
		if [ ! -z "$install_pid" ];then
        		cpu=$(ps -p $install_pid -o %cpu,%mem,cmd | awk 'END{print}' |awk '{print $1}') > /dev/null 2>&1
        		memory=$(ps -p $install_pid -o %cpu,%mem,cmd | awk 'END{print}' |awk '{print $2}') > /dev/null 2>&1
        		location=$(ps -p $install_pid -o %cpu,%mem,cmd | awk 'END{print}' |awk '{print $3" "$4" "$5}') > /dev/null 2>&1
        		echo -e "install-agent - Log Forwarder"
        		echo -e "   Loaded: loaded $location"
        		echo -e "   Active: \033[0;32mactive (running)\033[0m"
        		echo -e "     Docs: https://www.formcept.com"
        		echo -e " Main PID: $install_pid (install)"
        		echo -e "   Memory: $memory%"
        		echo -e "      CPU: $cpu%"
        		echo -e "     Mode: standalone"
		else
        		echo -e "install-agent - Log Forwarder"
        		echo -e "   Loaded: -"
        		echo -e "   Active: \033[0;31minactive (dead)\033[0m"
        		echo -e "     Docs: https://www.formcept.com"
        		echo -e " Main PID: - "
        		echo -e "   Memory: - "
        		echo -e "      CPU: - "
        		echo -e "     Mode: Error contacting service. It is probably not running."
		fi

	else	
		echo ""
		echo -e "\033[0;31mplease insert correct command!\033[0m"
		echo ""
	fi
else
	echo ""
	echo -e "\033[0;31minstall command not found!\033[0m"
        echo ""
fi

