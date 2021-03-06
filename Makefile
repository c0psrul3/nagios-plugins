#
#  Author: Hari Sekhon
#  Date: 2013-02-03 10:25:36 +0000 (Sun, 03 Feb 2013)
#
#  https://github.com/harisekhon/nagios-plugins
#
#  License: see accompanying Hari Sekhon LICENSE file
#
#  If you're using my code you're welcome to connect with me on LinkedIn and optionally send me feedback
#  to help improve or steer this or other code I publish
#
#  https://www.linkedin.com/in/harisekhon
#

export PATH := $(PATH):/usr/local/bin

CPANM = cpanm

ifdef PERLBREW_PERL
	SUDO2 =
else
	SUDO2 = sudo
endif

# Travis has custom python install earlier in $PATH even in Perl builds so need to install PyPI modules locally to non-system python otherwise they're not found by programs.
# Perms not set correctly on custom python install in Travis perl build so workaround is done to chown to travis user in .travis.yml
# Better than modifying $PATH to put /usr/bin first which is likely to affect many other things including potentially not finding the perlbrew installation first
#ifdef VIRTUAL_ENV
ifneq '$(VIRTUAL_ENV)$(CONDA_DEFAULT_ENV)$(TRAVIS)' ''
	SUDO3 =
else
	SUDO3 = sudo -H
endif

# must come after to reset SUDO2/SUDO3 to blank if root
# EUID /  UID not exported in Make
# USER not populated in Docker
ifeq '$(shell id -u)' '0'
	SUDO =
	SUDO2 =
	SUDO3 =
else
	SUDO = sudo
endif

.PHONY: build
# space here prevents weird validation warning from check_makefile.sh => Makefile:40: warning: undefined variable `D'
build :
	make common
	make perl-libs
	make python-libs

.PHONY: common
common:
	make submodules
	make system-packages

.PHONY: submodules
submodules:
	git submodule init
	git submodule update --recursive

.PHONY: system-packages
system-packages:
	if [ -x /sbin/apk ];        then make apk-packages; fi
	if [ -x /usr/bin/apt-get ]; then make apt-packages; fi
	if [ -x /usr/bin/yum ];     then make yum-packages; fi
	
.PHONY: perl
perl:
	make common
	make perl-libs

.PHONY: perl-libs
perl-libs:
	cd lib && make

	# XXX: there is a bug in the Readonly module that MongoDB::MongoClient uses. It tries to call Readonly::XS but there is some kind of MAGIC_COOKIE mismatch and Readonly::XS errors out with:
	#
	# Readonly::XS is not a standalone module. You should not use it directly. at /usr/local/lib64/perl5/Readonly/XS.pm line 34.
	#
	# Workaround is to edit Readonly.pm and comment out line 33 which does the eval 'use Readonly::XS';
	# On Linux this is located at:
	#
	# /usr/local/share/perl5/Readonly.pm
	#
	# On my Mac OS X Mavericks:
	#
	# /Library/Perl/5.16/Readonly.pm

	# Required to successfully build the MongoDB module for For RHEL 5
	#sudo cpan Attribute::Handlers
	#sudo cpan Params::Validate
	#sudo cpan DateTime::Locale DateTime::TimeZone
	#sudo cpan DateTime

	# You may need to set this to get the DBD::mysql module to install if you have mysql installed locally to /usr/local/mysql
	#export DYLD_LIBRARY_PATH="$DYLD_LIBRARY_PATH:/usr/local/mysql/lib/"

	@#@ [ $$EUID -eq 0 ] || { echo "error: must be root to install cpan modules"; exit 1; }
	
	# add -E to sudo to preserve http proxy env vars or run this manually if needed (only works on Mac)
	
	which cpanm || { yes "" | $(SUDO2) cpan App::cpanminus; }
	yes "" | $(SUDO2) $(CPANM) --notest `sed 's/#.*//; /^[[:space:]]*$$/d;' < setup/cpan-requirements.txt`
	
	# newer versions of the Redis module require Perl >= 5.10, this will install the older compatible version for RHEL5/CentOS5 servers still running Perl 5.8 if the latest module fails
	# the backdated version might not be the perfect version, found by digging around in the git repo
	$(SUDO2) $(CPANM) --notest Redis || $(SUDO2) $(CPANM) --notest DAMS/Redis-1.976.tar.gz

	# Fix for Kafka dependency bug in NetAddr::IP::InetBase
	libfilepath=`perl -MNetAddr::IP::InetBase -e 'print $$INC{"NetAddr/IP/InetBase.pm"}'`; grep -q 'use Socket' $$libfilepath || $(SUDO2) sed -i.bak "s/use strict;/use strict; use Socket;/" $$libfilepath


.PHONY: python
python:
	make common
	make python-libs

.PHONY: python-libs
python-libs:
	cd pylib && make

	# newer version of setuptools (>=0.9.6) is needed to install cassandra-driver
	# might need to specify /usr/bin/easy_install or make /usr/bin first in path as sometimes there are version conflicts with Python's easy_install
	$(SUDO) easy_install -U setuptools || $(SUDO3) easy_install -U setuptools || :
	$(SUDO) easy_install pip || :
	# cassandra-driver is needed for check_cassandra_write.py + check_cassandra_query.py
	# upgrade required to get install to work properly on Debian
	$(SUDO) pip install --upgrade pip
	$(SUDO3) pip install --upgrade -r requirements.txt
	# in requirements.txt now
	#$(SUDO3) pip install cassandra-driver scales blist lz4 python-snappy
	# prevents https://urllib3.readthedocs.io/en/latest/security.html#insecureplatformwarning
	$(SUDO3) pip install --upgrade ndg-httpsclient
	#. tests/utils.sh; $(SUDO) $$perl couchbase-csdk-setup
	#$(SUDO3) pip install couchbase
	
	# install MySQLdb python module for check_logserver.py / check_syslog_mysql.py
	# fails if MySQL isn't installed locally
	$(SUDO3) pip install MySQL-python
	@echo
	#make jar-plugins
	wget https://raw.githubusercontent.com/HariSekhon/pytools/master/find_active_server.py
	@echo
	@echo "BUILD SUCCESSFUL (nagios-plugins)"

.PHONY: elasticsearch2
elasticsearch2:
	$(SUDO3) pip install --upgrade 'elasticsearch>=2.0.0,<3.0.0'
	$(SUDO3) pip install --upgrade 'elasticsearch-dsl>=2.0.0,<3.0.0'

.PHONY: apk-packages
apk-packages:
	$(SUDO) apk update
	$(SUDO) apk add `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/apk-packages.txt`

.PHONY: apk-packages-remove
apk-packages-remove:
	cd lib && make apk-packages-remove
	$(SUDO) apk del `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/apk-packages-dev.txt` || :
	$(SUDO) rm -fr /var/cache/apk/*

.PHONY: apt-packages
apt-packages:
	$(SUDO) apt-get update
	$(SUDO) apt-get install -y `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/deb-packages.txt`
	# for check_whois.pl - looks like this has been removed from repos :-/
	$(SUDO) apt-get install -y jwhois || :

.PHONY: apt-packages-remove
apt-packages-remove:
	cd lib && make apt-packages-remove
	$(SUDO) apt-get purge -y `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/deb-packages-dev.txt`

.PHONY: yum-packages
yum-packages:
	# to fetch and untar ZooKeeper, plus wget epel rpm
	rpm -q wget || yum install -y wget
	
	# python-pip requires EPEL, so try to get the correct EPEL rpm
	# this doesn't work for some reason CentOS 5 gives 'error: skipping https://dl.fedoraproject.org/pub/epel/epel-release-latest-5.noarch.rpm - transfer failed - Unknown or unexpected error'
	# must instead do wget 
	rpm -q epel-release      || yum install -y epel-release || { wget -t 100 --retry-connrefused -O /tmp/epel.rpm "https://dl.fedoraproject.org/pub/epel/epel-release-latest-`grep -o '[[:digit:]]' /etc/*release | head -n1`.noarch.rpm" && $(SUDO) rpm -ivh /tmp/epel.rpm && rm -f /tmp/epel.rpm; }

	for x in `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/rpm-packages.txt`; do rpm -q $$x || $(SUDO) yum install -y $$x; done

	# breaks on CentOS 7.0 on Docker, fakesystemd conflicts with systemd, 7.2 works though
	rpm -q cyrus-sasl-devel || $(SUDO) yum install -y cyrus-sasl-devel || :

	# for check_yum.pl / check_yum.py
	rpm -q yum-security yum-plugin-security || yum install -y yum-security yum-plugin-security

.PHONY: yum-packages-remove
yum-packages-remove:
	cd lib && make yum-packages-remove
	for x in `sed 's/#.*//; /^[[:space:]]*$$/d' < setup/rpm-packages-dev.txt`; do rpm -q $$x && $(SUDO) yum remove -y $$x; done

# Net::ZooKeeper must be done separately due to the C library dependency it fails when attempting to install directly from CPAN. You will also need Net::ZooKeeper for check_zookeeper_znode.pl to be, see README.md or instructions at https://github.com/harisekhon/nagios-plugins
# doesn't build on Mac < 3.4.7 / 3.5.1 / 3.6.0 but the others are in the public mirrors yet
# https://issues.apache.org/jira/browse/ZOOKEEPER-2049
ZOOKEEPER_VERSION = 3.4.8
.PHONY: zookeeper
zookeeper:
	[ -x /sbin/apk ]        && make apk-packages || :
	[ -x /usr/bin/apt-get ] && make apt-packages || :
	[ -x /usr/bin/yum ]     && make yum-packages || :
	[ -f zookeeper-$(ZOOKEEPER_VERSION).tar.gz ] || wget -t 100 --retry-connrefused -O zookeeper-$(ZOOKEEPER_VERSION).tar.gz "http://www.apache.org/dyn/closer.lua?filename=zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz&action=download"
	[ -d zookeeper-$(ZOOKEEPER_VERSION) ] || tar zxf zookeeper-$(ZOOKEEPER_VERSION).tar.gz
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/c; 				./configure
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/c; 				make
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/c; 				$(SUDO) make install
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/contrib/zkperl; 	perl Makefile.PL --zookeeper-include=/usr/local/include --zookeeper-lib=/usr/local/lib
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/contrib/zkperl; 	LD_RUN_PATH=/usr/local/lib $(SUDO) make
	cd zookeeper-$(ZOOKEEPER_VERSION)/src/contrib/zkperl; 	$(SUDO) make install
	perl -e "use Net::ZooKeeper"

.PHONY: jar-plugins
jar-plugins:
	@echo Fetching pre-compiled Java / Scala plugins
	@echo
	@echo Fetching Kafka Scala Nagios Plugin
	wget -c -t 100 --retry-connrefused https://github.com/HariSekhon/nagios-plugin-kafka/blob/latest/check_kafka
	wget -c -t 100 --retry-connrefused https://github.com/HariSekhon/nagios-plugin-kafka/releases/download/latest/check_kafka.jar

.PHONY: sonar
sonar:
	sonar-scanner

.PHONY: test
test:
	cd lib && make test
	rm -fr lib/cover_db || :
	cd pylib && make test
	tests/all.sh

.PHONY: install
install:
	@echo "No installation needed, just add '$(PWD)' to your \$$PATH and Nagios commands.cfg"

.PHONY: update
update:
	@make update2
	@make

.PHONY: update2
update2:
	make update-no-recompile

.PHONY: update-no-recompile
update-no-recompile:
	git pull
	git submodule update --init --recursive

.PHONY: update-submodules
update-submodules:
	git submodule update --init --remote
.PHONY: updatem
updatem:
	make update-submodules

.PHONY: clean
clean:
	cd lib && make clean
	cd pylib && make clean
	@find . -maxdepth 3 -iname '*.py[co]' -o -iname '*.jy[co]' | xargs rm -f || :
	@make clean-zookeeper
	rm -fr tests/spark-*-bin-hadoop*

.PHONY: clean-zookeeper
clean-zookeeper:
	rm -fr zookeeper-$(ZOOKEEPER_VERSION).tar.gz zookeeper-$(ZOOKEEPER_VERSION)

.PHONY: docker
docker:
	docker run -ti --rm -v $$PWD:/pl harisekhon/nagios-plugins bash -c "cd /pl; exec bash"
