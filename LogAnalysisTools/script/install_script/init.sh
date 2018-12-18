#!/bin/bash
# Maintainer AnilKumar Patel
set -e
# it will continously check the status of install.sh file, and it will also check install.sh file is forcefully killed.
while true
do
install_service_status()
{
install_pid=$(ps aux | grep install.sh | egrep -v "grep|Helper" | awk '{print $2}')
if [ -z "$install_pid" ]; then
      echo -e "\033[0;31minstall Service is aborted ..\033[0m"
      break
   fi
}
install_service_status
sleep 1
done
exit
