# Log_Analysis

Log_Analysis is capable of collecting, correlating, and analysing machine data to give comprehensive real-time insights into operational performance. It can be used to perform various log Management tasks such as:

- Log collection (SL4J, Log4J, Machine logs, Custom Log plugin)
- AI/ML ready Logs’ data lake at scale
- Secured, Reliable and Access controlled Data
- Automatic linkages of devices, applications across the logs
- Automatic alerts through Email, SMS or Custom Plugins based on the anomalies across the devices or applications

# Log analysis components

- Elasticsearch -6.1.1
- logstash -6.1.1
- filebeat -6.1.1
- metricbeat -6.1.1
- kafka -1.0.0
- zookeeper -3.4.8
- kibana -6.1.1
 
### Installation
Installation steps for above components. 
Download Elasticsearch-6.1.1.tar.gz from official website. 
```sh
$ tar -xvf elasticsearch-6.1.1.tar.gz
$ cd elasticsearch
# replace the configuration from the above elasticsearch folder.
# download the elastic search head plugin.
$ git clone git://github.com/mobz/elasticsearch-head.git
$ cd elasticsearch-head
# Install
$ npm install
# Setup PM2
$ sudo npm install pm2 -g
# go inside elasticsearch folder and start the elasticsearch
$ ./bin/elasticsearch &
```

Download filebeat-6.1.1.tar.gz from official website. 
```sh
$ tar -xvf filebeat-6.1.1.tar.gz
$ cd filebeat-6.1.1
# replace the configuration from the above filebeat folder.
# go inside filebeat folder and start the filebeat
$ ./filebeat -e -c filebeat.yml -d "publish"
```

Download metricbeat-6.1.1.tar.gz from official website. 
```sh
$ tar -xvf metricbeat-6.1.1.tar.gz
$ cd metricbeat-6.1.1
# replace the configuration from the above metricbeat folder.
# go inside metricbeat folder and start the metrcibeat
$ ./metricbeat -e -c metricbeat.yml -d "publish"
```
Download logstash-6.1.1.tar.gz from official website. 
```sh
$ tar -xvf logstash-6.1.1.tar.gz
$ cd logstash-6.1.1
# replace the configuration from the given logstash.conf file.
# go inside logstash folder and start the logstahs
$ ./bin/logstash -f logstash.conf
```
### Logstash configuration for jmx matrix
Download the latest Tomcat7 version 7.0.62 from given link [https://tomcat.apache.org/download-70.cgi](https://tomcat.apache.org/download-70.cgi)
##### Steps to configure tomcat server for Jmx data

```sh
# extract the tomcat server and go to apache-tomcat-7.0.85/conf/server.xml and add a line in <connector> tag.
address="192.168.1.x"
 
#create a file setenv.sh in apache-tomcat-7.0.85/bin and add the following configurations.
CATALINA_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9000 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djava.rmi.server.hostname=192.168.1.x"

#start the tomcat server
$ ./bin/startup.sh

# replace the configuration from the above logstash folder. 
logstash_jmx.conf
jmx_config.json

# download the logstash jmx plugin
$ cd logstash-6.1.1
$ ./bin/logstash-plugin install logstash-input-jmx

# start the logstash jmx plugin
$ cd logstash-6.1.1
$ ./bin/logstash -f logstash_jmx.conf
```

### Logstash configuration for winlogbeat
```sh
# download winlogbeat-6.1.1 from the official website.

# extract winlogbeat in C Drive of your Microsoft Operating System at location C:\

# Use Powershell in windows for running and configuring the winlogbeat

# open powershell & Type

$ Get-EventLog *

# This command will show all the logs that are present inside your OS.

# Then copy the configuration from above winloag beat and paste inside your winlogbeat.yml file.

# start the winlogbeat

$ .\winlogbeat.exe -c .\winlogbeat.yml

```

### Logstash configuration for packetbeat
```sh
# download packetbeat-6.1.1 from the official website.

# extract packetbeat & copy the configuration from above packetbeat directory.

# start the packetbeat

$ ./packetbeat -e -c packetbeat.yml -d "publish"

```
