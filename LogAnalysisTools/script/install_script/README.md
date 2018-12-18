# Log Analysis
Log Analysis is capable of collecting, correlating, and analysing machine data to give comprehensive real-time insights into operational performance. It can be used to perform various log Management tasks such as:
- Log collection (SL4J, Log4J, Machine logs, Custom Log plugin)
- AI/ML ready Logs’ data lake at scale
- Secured, Reliable and Access controlled Data
- Automatic linkages of devices, applications across the logs
- Automatic alerts through Email, SMS or Custom Plugins based on the anomalies across the devices or applications

### Log Analysis Installation

Clone the Log Analysis code.

### prerequisite.
- OS should be centos-7 or Ubuntu

### Steps for Installation
```sh
# user need to define their log file location at log.conf file with their customs tags.
# example:- /var/log/messages this the location of syslog file then user need to declare tag with location in log.conf file.
  [syslog_file]
  /var/log/messages

# make the executable of install.sh file.
$ sudo chmod 775 install.sh

# replace the kafka ip with your kafka ip.

# start the Log Analysis
$ ./install.sh start

# stop the Log Analysis
$ ./install.sh stop

# check status
$ ./install.sh status
