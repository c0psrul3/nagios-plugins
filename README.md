Advanced Nagios Plugins Collection
==================================
[![Build Status](https://travis-ci.org/HariSekhon/nagios-plugins.svg?branch=master)](https://travis-ci.org/HariSekhon/nagios-plugins)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e6fcf7cb4dcc4905ab0a4cb91567fdda)](https://www.codacy.com/app/harisekhon/nagios-plugins)
[![GitHub stars](https://img.shields.io/github/stars/harisekhon/nagios-plugins.svg)](https://github.com/harisekhon/nagios-plugins/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/harisekhon/nagios-plugins.svg)](https://github.com/harisekhon/nagios-plugins/network)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20OS%20X-blue.svg)](https://github.com/harisekhon/nagios-plugins#advanced-nagios-plugins-collection)
[![DockerHub](https://img.shields.io/badge/docker-available-blue.svg)](https://hub.docker.com/r/harisekhon/nagios-plugins/)
[![](https://images.microbadger.com/badges/image/harisekhon/nagios-plugins.svg)](http://microbadger.com/#/images/harisekhon/nagios-plugins)
<!-- broken handling of Elasticsearch major version for Python library [![Dependency Status](https://gemnasium.com/badges/github.com/HariSekhon/nagios-plugins.svg)](https://gemnasium.com/github.com/HariSekhon/nagios-plugins)-->

Largest and most advanced collection of unified production-grade Nagios monitoring code in the wild.

Largest collection of Hadoop & NoSQL monitoring code, written by a former Clouderan ([Cloudera](http://www.cloudera.com) was the first Hadoop Big Data vendor).

Hadoop and extensive API integration with all major Hadoop vendors ([Hortonworks](http://www.hortonworks.com), [Cloudera](http://www.cloudera.com), [MapR](http://www.mapr.com), [IBM BigInsights](http://www-03.ibm.com/software/products/en/ibm-biginsights-for-apache-hadoop)).

Extends a variety of [compatible Enterprise Monitoring Systems](https://github.com/harisekhon/nagios-plugins#enterprise-monitoring-systems), can also be used standalone on the command line, in scripts etc.

Most enterprise monitoring systems come with basic generic checks, while this project extends their monitoring capabilities significantly further in to advanced infrastructure, application layer, APIs etc.

It's a treasure trove of essentials for every single "DevOp", sysadmin or engineer, with extensive goodies for those running Web Infrastructure,
[Hadoop](http://hadoop.apache.org/),
[Kafka](http://kafka.apache.org/),
[Mesos](http://mesos.apache.org/)
and NoSQL technologies ([Cassandra](http://cassandra.apache.org/),
[HBase](https://hbase.apache.org/),
[MongoDB](https://www.mongodb.com/),
[Riak](http://basho.com/products/),
[Couchbase](http://www.couchbase.com/),
[Memcached](https://memcached.org/),
[Redis](http://redis.io/),
[Solr / SolrCloud](http://lucene.apache.org/solr/),
[Elasticsearch](https://www.elastic.co/products/elasticsearch)
...) etc.

Fix requests, suggestions, updates and improvements are most welcome via Github [issues](https://github.com/harisekhon/nagios-plugins/issues) or [pull requests](https://github.com/harisekhon/nagios-plugins/pulls).

Hari Sekhon

Big Data Contractor, United Kingdom

https://www.linkedin.com/in/harisekhon


##### Make sure you run ```make update``` if updating and not just ```git pull``` as you will often need the latest library submodules and probably new upstream libraries too.

### Quick Start ###

#### Ready to run Docker image #####

All plugins and their pre-compiled dependencies can be found ready to run on [DockerHub](https://hub.docker.com/r/harisekhon/nagios-plugins/).

List all plugins:
```
docker run harisekhon/nagios-plugins
```
Run any given plugin:
```
docker run harisekhon/nagios-plugins <check_plugin> <args>
```

#### Automated Build from Source

```
git clone https://github.com/harisekhon/nagios-plugins
cd nagios-plugins
make
```

To build just the Perl or Python dependencies for the project you can do ``` make perl ``` or ``` make python ```.

Don't copy plugins out as most require the co-located libraries I've written so you should ```git clone && make``` on each machine you deploy this code to or just use Docker - it's much simpler.

Be aware the ```make``` build will install yum rpms / apt debs automatically as well as a load of Perl CPAN & Python PyPI libraries. If you don't want all that stuff automatically installed you must follow the [Manual Build](https://github.com/harisekhon/nagios-plugins#manual-build) section instead. You may need to install the GNU make system package if the ```make``` command isn't found (```yum install make``` / ```apt-get install make```)

Also be aware this has become quite a large project and will take at least 10 minutes to build. Just be glad it's automated and tested on RHEL/CentOS 5/6/7 & Debian/Ubuntu systems. Build will work on Mac OS X too but will not handle system package dependencies.
<!--
Make sure /usr/local/bin is in your $PATH when running make as otherwise it'll fail to find ```cpanm```
-->

This automated build will use 'sudo' to install required Perl CPAN & Python PyPI libraries to the system unless running inside Perlbrew or VirtualEnv. If you want to install some of the common Perl / Python libraries such as Net::DNS and LWP::* using your OS packages instead of installing from CPAN / PyPI then follow the [Manual Build](https://github.com/harisekhon/nagios-plugins#manual-build) section instead.

If wanting to use any of ZooKeeper znode checks for HBase/SolrCloud etc based on check_zookeeper_znode.pl or any of the check_solrcloud_*_zookeeper.pl programs you will also need to install the zookeeper libraries which has a separate build target due to having to install C bindings as well as the library itself on the local system. This will explicitly fetch the tested ZooKeeper 3.4.8, you'd have to update the ```ZOOKEEPER_VERSION``` variable in the Makefile if you want a different version.

```
make zookeeper
```
This downloads, builds and installs the ZooKeeper C bindings which Net::ZooKeeper needs. To clean up the working directory afterwards run:
```
make clean-zookeeper
```

### Usage --help ###

All plugins come with --help which lists all options as well as giving a program description, often including a detailed account of what is checked in the code.

Some common options also support optional environment variables for convenience to reduce repeated --switch usage or to hide them from being exposed in the process list. These are indicated in the --help descriptions in brackets next to each option eg. $HOST, $PASSWORD or more specific ones with higher precedence like $ELASTICSEARCH_HOST, $REDIS_PASSWORD etc.

Make sure to install the required Perl CPAN modules first before calling --help.

### A Sample of cool Nagios Plugins in this collection ###

- ```check_ssl_cert.pl``` - SSL expiry, chain of trust (including intermediate certs important for certain mobile devices), SNI, domain, wildcard and multi-domain support validation
- ```check_whois.pl``` - check domain expiry days left and registration details match expected
- ```check_mysql_query.pl``` - generic enough it obsoleted a dozen custom MySQL plugins and prevented writing many more
- ```check_mysql_config.pl``` - detect differences in your /etc/my.cnf and running MySQL config to catch DBAs making changes to running databases without saving to /etc/my.cnf or backporting to Puppet. Can also be used to remotely validate configuration compliance against a known good baseline
- ```check_hadoop_*.pl``` - various Apache Hadoop monitoring utilities for HDFS, YARN and MapReduce (both MRv1 & MRv2) including HDFS cluster balance, block replication, space, block count limits per datanode / cluster total, node counts, dead Datanodes/TaskTrackers/NodeManagers, blacklisted TaskTrackers, unhealthy NodeManagers, Namenode & JobTracker / Yarn Resource Manager heap usage, NameNode & JobTracker HA, NameNode safe mode, WebHDFS (with HDFS HA failover support), HttpFS, HDFS writeability, HDFS fsck status / last check / run time / max blocks, HDFS file / directory existence & metadata attributes, gather metrics and JMX information
- ```check_kafka.pl / check_kafka.py``` - checks Kafka brokers end-to-end via API, acts as both a producer and a consumer and checks that a unique generated message passes through the Kafka broker cluster successfully
- ```check_hbase_*.pl``` - various HBase monitoring utilities using Thrift + Stargate APIs, checking Masters / Backup Masters, RegionServers, table availability (exists, is enabled, and has minimum number of column families), number of expected table regions, unassigned table regions, regions stuck in transition, region count balance across RegionServers, compaction in progress (by table and by regionserver), number of regions in transition, longest current region migration time, hbck status and any inconsistencies, cell content vs optional regex + thresholds, table write and read back of unique generated values with write/read/delete latency checks against all detected column families, table write spray and read back of unique values across all regions for all column families with write/read/delete latency checks, gather metrics
- ```check_cassandra_*.pl / check_datastax_opscenter_*.pl``` - Cassandra and DataStax OpsCenter monitoring, including Cassandra cluster nodes, token balance, space, heap, keyspace replication settings, alerts, backups, best practice rule checks, DSE hadoop analytics service status and both nodetool and DataStax OpsCenter collected metrics
- ```check_solr*.pl``` - checks for Solr and SolrCloud including API write/read/delete, arbitrary Solr queries vs num matching documents, API ping, Solr Core Heap / Index Size / Number of Docs for a given Solr Collection, and thresholds in ms against all Solr API operations as well as perfdata for graphing, as well as SolrCloud ZooKeeper content checks for collection shards and replicas states, number of live nodes in SolrCloud cluster, overseer, SolrCloud config and Solr metrics.
- ```check_elasticsearch_*.pl``` - checks Elasticsearch cluster state, shards, replicas, number of nodes & data nodes online, shard and disk % balance between nodes, single node ok, specific node found in cluster state, pending tasks on a node, elasticsearch / lucene versions, per index existence / shards / replicas / settings / age, stats per cluster / index / node
- ```check_ambari_*.pl``` - Hadoop cluster checks via Hortonworks Ambari API - checks the service status, node(s) status, stale configs, cluster alerts summary, host alerts summary, cluster health report, kerberos enabled, cluster version, service config compatible with stack and cluster
- ```check_cloudera_manager_*.pl``` - Hadoop cluster checks via Cloudera Manager API - checks states and health of cluster services/roles/nodes, management services, config staleness, Cloudera Enterprise license expiry, Cloudera Manager and CDH cluster versions, utility switches to list clusters/services/roles/nodes as well as list users and their role privileges, fetch a wealth of Hadoop & OS monitoring metrics from Cloudera Manager and compare to thresholds. Disclaimer: I worked for Cloudera, but seriously CM collects an impressive amount of metrics making check_cloudera_manager_metrics.pl alone a very versatile program from which to create hundreds of checks to flexibly alert on
- ```check_mapr*.pl``` - Hadoop cluster checks via MapR Control System API - checks services and nodes, MapR-FS space (cluster and per volume), volume states, volume block replication, volume snapshots and mirroring, MapR-FS per disk space utilization on nodes, failed disks, CLDB heartbeats, MapR alarms, MapReduce mode and memory utilization, disk and role balancer metrics. These are noticeably faster than running equivalent maprcli commands (exceptions: disk/role balancer use maprcli).
- ```check_ibm_biginsights_*.pl``` - Hadoop cluster checks via IBM BigInsights Console API - checks services, nodes, agents, BigSheets workbook runs, dfs paths and properties, HDFS space and block replication, BI console version, BI console applications deployed
- ```check_apache_drill_*``` - check Apache Drill status and metrics for a given node, apply thresholds to a given metric or return multiple or all metrics
- ```check_riak_*.pl``` - check Riak API writes/reads/deletes with timings, check a specific key's value against regex or value range, check all riak diagnostics, check node states, check all nodes agree on ring status, gather statistics, alert on any single stat
- ```check_redis_*.pl``` - check Redis API writes/reads/deletes with timings, check specific key's value against regex or value range, replication slaves I/O, replicated writes (write on master -> read from slave), publish/subscribe, connected clients, validate redis.conf against running server to check deployments or remote compliance checks, gather statistics, alert on any single stat
- ```check_memcached_*.pl``` - check Memcached API writes/reads/deletes with timings, check specific key's value against regex or value range, number of current connections, gather statistics
- ```check_mesos_*.pl``` - check Mesos master health API, master & slaves state information including leader and versions, activated & deactivated slaves, number of Chronos jobs, master & slave metrics
- ```check_zookeeper.pl``` - ZooKeeper server checks, multiple layers: "is ok" status, is writable (quorum), operating mode (leader/follower vs standalone), gather statistics
- ```check_zookeeper_*znode*.pl``` - ZooKeeper znode checks using ZK Perl API, useful for HBase, Kafka, SolrCloud, Hadoop NameNode HA & JobTracker HA (ZKFC) and any other ZooKeeper based service. Very versatile with multiple optional checks including data vs regex, json field extraction, ephemeral status, child znodes, znode last modified age
- ```check_puppet.rb``` - thorough, find out when Puppet stops properly applying manifests, if it's in the right environment, if it's --disabled, right puppet version etc
- ```check_aws_s3_file.pl``` - check for the existence of any arbitrary file on AWS S3, eg. to check backups have happened or _SUCCESS placeholder files are present for a job
- ```check_travis_ci_last_build.py``` - checks the last build status of a given Travis CI repo showing build number, duration, start/stop times, if there are currently any builds in progress and perfdata for graphing last build time and number of builds in progress. Verbose mode gives the commit details as well
- ```check_yum.py / check_yum.pl``` - widely used yum security updates checker for RHEL 5 - 7 systems dating back to 2008. You'll find forks of this around including NagiosExchange but please re-unify on this central updated version. Also has a Perl version which is a newer straight port with nicer more concise code and better library backing as well as configurable self-timeout.

... and there are many more.

This code base is under active development and there are many more cool plugins pending import.

### See Also

- ```find_active_server.py``` - returns the first available healthy server or determines the active master in high availability setups. Configurable tests include socket, http, https, ping, url with optional regex content match and is multi-threaded for speed. Useful for pre-determining a server to be passed to tools that only take a single ```--host``` argument but for which the technology has later added multi-master support or active-standby masters (eg. Hadoop, HBase) or where you want to query cluster wide information available from any online peer (eg. Elasticsearch). This is downloaded from my [PyTools repo](https://github.com/harisekhon/pytools#hari-sekhon-pytools) as part of the build and placed at the top level. It has the ability to extend any nagios plugin to support multiple hosts in a generic way, eg:

```
./check_elasticsearch_cluster_status.pl --host $(./find_active_server.py -v --http --port 9200 node1 node2 node3)
```

### Kerberos Security Support ###

For HTTP based plugins Kerberos is implicitly supported by LWP as long as the LWP::Authen::Negotiate CPAN module is installed (part of the automated ```make``` build). This will look for a valid TGT in the environment and if found will use it for SPNego.

### Quality ###

Most of the plugins I've read from Nagios Exchange and Monitoring Exchange (now Icinga Exchange) in the last decade have not been of the quality required to run in production environments I've worked in (ever seen plugins written in Bash with little validation, or mere 200-300 line plugins without robust input/output validation and error handling, resulting in "UNKNOWN: (null)" when something goes wrong - right when you need them - then you know what I mean). That prompted me to write my own plugins whenever I had an idea or requirement.

That naturally evolved in to this, a relatively Advanced Collection of Nagios Plugins, especially when I began standardizing and reusing code between plugins and improving the quality of all those plugins while doing so.

##### Goals #####

- specific error messages to aid faster Root Cause Analysis
- consistent behaviour
- standardized switches
- strict input/output validation at all stages, written for security and robustness
- multiple verbosity levels
- self-timeouts
- graphing data where appropriate (use PNP4Nagios for automatic graphing)
- code reuse, especially for more complex input/output validations and error handling
- support for use of $USERNAME and $PASSWORD environment variables as well as more specific overrides (eg. $MYSQL_USERNAME, $REDIS_PASSWORD) to give administrators the option to avoid leaking ```--password``` credentials in the process list for all users to see
- continuous integration with tests for success and failure scenarios:
  - unit tests for the custom supporting libraries
  - functional tests for the top level programs using Dockerized containers for each technology (eg. Cassandra, Elasticsearch, Hadoop, HBase, ZooKeeper, Memcached, Neo4j, MongoDB, MySQL, Riak, Redis...)
- easy rapid development of new high quality robust Nagios plugins with minimal lines of code

Several plugins have been merged together and replaced with symlinks to the unified plugins bookmarking their areas of functionality, similar to some plugins from the standard nagios plugins collection.

Some plugins such as those relating to Redis and Couchbase also have different modes and expose different options when called as different program names, so those symlinks are not just cosmetic. An example of this is write replication, which exposes extra options to read from a slave after writing to the master to check that replication is 100% working.

ePN optimization is not supported at this time by any of the plugins as I ran 13,000 checks per Nagios server years ago without ePN optimization - it's not worth the effort.

##### Contributions #####

Patches, improvements and even general feedback are welcome in the form of GitHub pull requests and issue tickets.

Examples of your usage and outputs are also welcome for the Wiki as some of these plugins allow a great diversity of checks to be created - for example, free form MySQL queries or ZooKeeper contents checks can be used to check pretty much anything that advanced DBAs and applications/operations personnel can think of with a just a few command line --switches.

##### Library #####

Having written a large number of Nagios Plugins in the last several years in a variety of languages (Python, Perl, Ruby, Bash, VBS) I abstracted out common components of a good robust Nagios Plugin program in to a library of reusable components that I leverage very heavily in all my modern plugins and other programs found under my other repos here on GitHub, which are now mostly written in Perl using this library, for reasons of both concise rapid development and speed of execution.

This Library enables writing much more thoroughly validated production quality code, to achieve in a quick 200 lines of Perl what might otherwise take 1500-2000 lines (including some of the more complicated supporting code such as robust validation functions with long complex regexs, configurable self-timeouts, warning/critical threshold range logic, common options and generated usage, multiple levels of verbosity, debug mode etc), dramatically reducing the time to write high quality plugins down to mere hours and at the same time vastly improving the quality of the final code through code reuse, as well as benefitting from generic future improvements to the library.

This gives each plugin the appearance of being very short, because only the core logic of what you're trying to achieve is displayed in the plugin itself, mostly composition of utility functions, and the error handling is often handled in a library too, so it may appear that a simple one line 'curl()' or 'open_file()' utility function call has no error handling at all around it but under the hood the error handling is handled inside the function inside a library, same for HBase Thrift API connection, Redis API connection etc so the client code as seen in the top level plugins knows it succeeded or otherwise the framework would have errored out with a specific error message such as "connection refused" etc... there is a lot of buried error checking code and a lot of utility functions so many operations become one-liners at the top level instead of huge programs that are hard to read and maintain.

I've tried to keep the quality here high so a lot of plugins I've written over the years haven't made it in to this collection, there are a lot still pending import, a couple others ```check_nsca.pl``` and ```check_syslog-ng_stats.pl``` are in the more/ directory until I get round to reintegrating and testing them with my current framework to modernize them, although they should still work with the tiny utils.pm from the standard nagios plugins collection.

I'm aware of Nagios::Plugin but my library has a lot more utility functions in it and I've written it to be highly convenient for me to develop with.

###### Older Plugins ######

Some older plugins (especially those written in languages other than Perl) may not adhere to all of the criteria above so most have been filed away under the older/ directory (they were used by people out there in production so I didn't want to remove them entirely). Older plugins also indicate that I haven't run or made updates to them in a few years so those may require tweaks and updates.

If you're new remember to check out the older/ directory for more plugins that are less current but that you might find useful.

### Manual Build ###

Fetch my library repo which is included as a submodule (it's shared between these Nagios Plugins and other programs I've written over the years).

```
git clone https://github.com/harisekhon/nagios-plugins
cd nagios-plugins
git submodule init
git submodule update
```

Then install the Perl CPAN and Python modules as listed in the next sections.

##### Perl CPAN Modules #####

If installing the Perl CPAN modules via your package manager or by hand instead of running the 'make' command as listed in Quick Setup, then read the 'Makefile' file for the list of Perl CPAN modules that you need to install.

###### Net::ZooKeeper (for various ZooKeeper content checks for Kafka, HBase, SolrCloud etc) ######

```
check_zookeeper_znode.pl
check_zookeeper_child_znodes.pl
check_hbase_*_znode.pl
check_solrcloud_*_zookeeper.pl
```

The above listed programs require the Net::ZooKeeper Perl CPAN module but this is not a simple ```cpan Net::ZooKeeper```, that will fail. Follow these instructions precisely or debug at your own peril:

```
# install C client library
export ZOOKEEPER_VERSION=3.4.8
[ -f zookeeper-$ZOOKEEPER_VERSION.tar.gz ] || wget -O zookeeper-$ZOOKEEPER_VERSION.tar.gz http://www.mirrorservice.org/sites/ftp.apache.org/zookeeper/zookeeper-$ZOOKEEPER_VERSION/zookeeper-$ZOOKEEPER_VERSION.tar.gz
tar zxvf zookeeper-$ZOOKEEPER_VERSION.tar.gz
cd zookeeper-$ZOOKEEPER_VERSION/src/c
./configure
make
sudo make install

# now install Perl module using C library with the correct linking
cd ../contrib/zkperl
perl Makefile.PL --zookeeper-include=/usr/local/include/zookeeper --zookeeper-lib=/usr/local/lib
LD_RUN_PATH=/usr/local/lib make
sudo make install
```
After this check it's properly installed by doing
```perl -e "use Net::ZooKeeper"```
which should return no errors if successful.

### Other Dependencies ###

Some plugins, especially ones under the older/ directory such as those that check 3ware/LSI raid controllers, SVN, VNC etc require external binaries to work, but the plugins will tell you if they are missing. Please see the respective vendor websites for 3ware, LSI etc to fetch those binaries and then re-run those plugins.

The ```check_puppet.rb``` plugin uses Puppet's native Ruby libraries to parse the Puppet config and as such will only be run where Puppet is properly installed.

The ```check_logserver.py``` "Syslog to MySQL" plugin will need the Python MySQL module to be installed which you should be able to find via your package manager. If using RHEL/CentOS do:

```
sudo yum install MySQL-python
```

or try install via pip, but this requires MySQL to be installed locally in order to build the Python egg...
```
sudo easy_install pip
sudo pip install MySQL-python
```

#### Configuration for Strict Domain / FQDN validation ####

Strict validations include host/domain/FQDNs using TLDs which are populated from the official IANA list. This is done via the [Lib](https://github.com/harisekhon/lib) submodule - see there for details on configuring this to permit custom TLDs like ```.local``` or ```.intranet``` (both supported by default).

### Updating ###

Run ```make update```. This will git pull and then git submodule update which is necessary to pick up corresponding library updates.

If you update often and want to just quickly git pull + submodule update but skip rebuilding all those dependencies each time then run ```make update-no-recompile``` (will miss new library dependencies - do full ```make update``` if you encounter issues).

#### Testing

There is a full suite of Dockerized functional tests in the ```tests/``` directory as well as a high coverage percentage of unit tests for the underlying [Perl library](https://github.com/harisekhon/lib) and [Python library](https://githu.com/harisekhon/pylib) libraries.

Running ```make test``` will trigger all tests, starting with the underlying libraries and then moving on to the Dockerized functional test suites.

##### Bugs & Workarounds #####

###### Kafka dependency NetAddr/IP/InetBase autoload bug ######

If you encounter the following error when trying to use ```check_kafka.pl```:

```Can't locate auto/NetAddr/IP/InetBase/AF_INET6.al in @INC```

This is an upstream bug related to autoloader, which you can work around by editing ```NetAddr/IP/InetBase.pm``` and adding the following line explicitly near the top just after ```package NetAddr::IP::InetBase;```: 

```use Socket;```

On Linux this is often at ```/usr/local/lib64/perl5/NetAddr/IP/InetBase.pm``` and on Mac ```/System/Library/Perl/Extras/<version>/NetAddr/IP/InetBase.pm```.

You may also need to install Socket6 from CPAN.

This fix is now fully automated in the Make build by patching the ```NetAddr/IP/InetBase.pm``` file and always including Socket6 in dependencies.

Alternatively you can try the Python version ```check_kakfa.py``` which works in similar fashion.

###### MongoDB dependency Readonly library bug ######

The MongoDB Perl driver from CPAN doesn't seem to compile properly on RHEL5 based systems. PyMongo rewrite was considered but the extensive library of functions results in better code quality for the Perl plugins, it's easier to just upgrade your OS to RHEL6.

The MongoDB Perl driver does compile on RHEL6 but there is a small bug in the Readonly CPAN module that the MongoDB CPAN module uses. When it tries to call Readonly::XS, a MAGIC_COOKIE mismatch results in the following error:
```
Readonly::XS is not a standalone module. You should not use it directly. at /usr/local/lib64/perl5/Readonly/XS.pm line 34.
```
The workaround is to edit the Readonly module and comment out the ```eval 'use Readonly::XS'``` on line 33 of the Readonly module.

This is located here on Linux:
```
/usr/local/share/perl5/Readonly.pm
```

and here on Max OS X:
```
/Library/Perl/5.16/Readonly.pm
```

###### IO::Socket::SSL doesn't respect ignoring self-signed certs in recent version(s) eg. 2.020 #####

Recent version(s) of IO::Socket::SSL (2.020) seem to fail to respect options to ignore self-signed certs. The workaround is to create the hidden touch file below in the same top-level directory as the library to make this it include and use Net::SSL instead of IO::Socket::SSL.

```
touch .use_net_ssl
```

#### Python SSL certificate verification problems

If you end up with an error like:
```
[SSL: CERTIFICATE_VERIFY_FAILED] certificate verify failed (_ssl.c:765)
```
It can be caused by an issue with the underlying Python + libraries due to changes in OpenSSL and certificates. One quick fix is to do the following:
```
pip uninstall -y certifi && pip install certifi==2015.04.28
```

### Support for Updates / Bugs Fixes / Feature Requests ###

Please raise a [Github Issue ticket](https://github.com/harisekhon/nagios-plugins/issues) for if you need updates, bug fixes or new features.

Since there are a lot of programs covering a lot of different technologies, look at the software ersions each program was written / tested against (documented in --help for each program). Newer versions of software seem to change a lot these days especially in the Big Data & NoSQL space so plugins may require updates for newer versions.

Please make sure you have run ```make update``` first to pull the latest updates including library sub-modules and build the latest CPAN module dependencies, (see [Quick Setup](https://github.com/harisekhon/nagios-plugins#quick-setup) above).

Make sure you run the code by hand on the command line with ```-v -v -v``` for additional debug output and paste the full output in to the issue ticket. If you want to anonymize your hostnames/IP addresses etc you may use the ```scrub.pl``` tool found in my [Tools repo](https://github.com/harisekhon/tools).

### Contributions ###

Contributions are more than welcome with patches accepted in the form of Github pull requests, for which you will receive attribution automatically as Github tracks these merges.

### Further Utilities ###

[Tools](https://github.com/harisekhon/tools) & [PyTools](https://github.com/harisekhon/pytools) repos - contains another 50+ programs including useful tools such as:
* Hive / Pig => Elasticsearch / SolrCloud indexers
* Hadoop HDFS performance debugger, native checksum extractor, file retention policy script, HDFS file stats, XML & running Hadoop cluster config differ
* ```watch_url.pl``` for debugging load balanced web farms
* tools for Ambari, Pig, Hive, Spark + IPython Notebook, Solr CLI
* code reCaser for SQL / Pig / Neo4j / Hive HQL / Cassandra / MySQL / PostgreSQL / Impala / MSSQL / Oracle / Dockerfiles
* ```scrub.pl``` anonymizes configs / logs for posting online - replaces hostnames/domains/FQDNs, IPs, passwords/keys in Cisco/Juniper configs, custom extensible phrases like your name or your company name
* ```validate_json/yaml/xml/avro/parquet.py``` - validates JSON, XML, YAML, Avro, Parquet including directory trees, standard input and even multi-record JSON as found in MongoDB and Hadoop / Big Data systems.
* PySpark Avro / CSV / JSON / Parquet data converters
* Ambari Blueprints tool & templates
* AWS CloudFormation templates
* DockerHub API tools including more search results and fetching repo tags (not available in official Docker tooling)

### See Also ###

* [My Perl library](https://github.com/harisekhon/lib) - used throughout this code as a submodule to make the programs in this repo short
* [My Python library](https://github.com/harisekhon/pylib) - Python version of the above library, also heavily leveraged to keep programs in this repo short
* [Spark => Elasticsearch](https://github.com/harisekhon/spark-apps) - Scala application to index from Spark to Elasticsearch. Used to index data in Hadoop clusters or local data via Spark standalone. This started as a Scala Spark port of ```pig-text-to-elasticsearch.pig``` from my [PyTools](https://github.com/harisekhon/pytools) repo

### Enterprise Monitoring Systems

The following enterprise monitoring systems are compatible with this project:

* [Nagios](https://www.nagios.org/) - the original widely used open source monitoring system that set the standard
  * [Nagios Command Configuration](http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#command)
  * [Nagios Service Configuration](http://nagios.sourceforge.net/docs/3_0/objectdefinitions.html#service)

* [Icinga](https://www.icinga.org/) - a newer alternative to classic Nagios

* [Sensu](https://sensuapp.org/) - another modern Nagios compatible alternative

* [Shinken](http://www.shinken-monitoring.org/) - a Nagios core reimplementation in Python

* [Geneos](https://www.itrsgroup.com/products/geneos-overview) - proprietary non-standard monitoring, was used by a couple of banks I worked for. Geneos does not follow Nagios standards so integration is provided via ```geneos_wrapper.py``` which if preprended to any standard nagios plugin command will execute and translate the results to the CSV format that Geneos expects, so Geneos can utilize any Nagios Plugin using this program.

* [Microsoft SCOM](https://www.microsoft.com/en-us/cloud-platform/system-center) - Microsoft Systems Center Operations Manager, can run Nagios Plugins as arbitrary Unix shell scripts with health/warning/error expression checks, see the [documentation](https://technet.microsoft.com/en-us/library/jj126087(v=sc.12).aspx).

##### Datameer

Datameer plugins referenced in [Datameer docs](https://www.datameer.com/documentation/current/Home) from version 3 onwards in the Links section along with the official Nagios links. See here for more information on Datameer monitoring with Nagios:

* https://www.datameer.com/documentation/current/Monitoring+Hadoop+and+Datameer+using+Nagios

After trying the 1 example plugin there, return to try the 9 plugins in this collection to extend your Datameer monitoring further.
