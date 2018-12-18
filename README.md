# Log Analysis

Anomaly detection plays an important role in management of modern large-scale distributed systems. Logs, which record system runtime information, are widely used for anomaly detection. Traditionally, developers (or operators) often inspect the logs manually with keyword search and rule matching. The increasing scale and complexity of modern systems, however, make the volume of logs explode, which renders the infeasibility of manual inspection. To reduce manual effort, many anomaly detection methods based on automated log analysis are proposed.

### Overview
1. **Log collection:** Logs are generated and collected by system and sofwares during running, which includes distributed systems (e.g., Spark, Hadoop), standalone systems (e.g., Windows, Mac OS) and softwares (e.g., Zookeeper).
2. **Log Parsing:** Raw Logs contain too much runtime information (e.g., IP address, file name). These variable information are often removed after log parsing as they are useless for debugging. After parsing, raw logs become log events, which are abstraction of raw logs. Details are given in our previous work: Logparser
3. **Feature Extraction:** Logs are grouped into log sequences via Task ID or time, and these log sequences are vectorized and weighted.
4. **Anomaly Detection:** Some machine learning models are trained and applied to detect anomalies.



