#!/bin/sh

#########################################
#
# Installation script for nfsen & nfdump
# Author : SMII Mondher
#
########################################

DIRECTORY=/usr/src
NFDUMP=http://sourceforge.net/projects/nfdump/files/stable/nfdump-1.6.8p1/nfdump-1.6.8p1.tar.gz
NFSEN=http://sourceforge.net/projects/nfsen/files/stable/nfsen-1.3.6p1/nfsen-1.3.6p1.tar.gz


#INSTALL DEPENDENCIE
apt-get install gcc flex librrd-dev make apache2 libapache2-mod-php5 php5-common libmailtools-perl rrdtool librrds-perl
#PERL DEPENDENCIE
perl -MCPAN -e 'install Socket6'

#INSTALL NFDUMP
cd $DIRECTORY
wget $NFDUMP
tar -xvzf nfdump-1.6.8p1.tar.gz
cd nfdump-1.6.8p1
./configure --enable-nfprofile
make && make install


#INSTALL NFSEN
cd $DIRECTORY
wget $NFSEN
cd nfsen-1.3.6p1
cp etc/nfsen-dist.conf /etc/nfsen.conf

#CREATE FOLDER NFSEN
mkdir -p /data/nfsen
./install.pl /etc/nfsen.conf
cd /data/nfsen/bin
./nfsen start

#MAKE NFSEN SERVICE
ln -s /data/nfsen/bin/nfsen /etc/init.d/nfsen
update-rc.d nfsen defaults 20

#INSTALL FPROBE
#interface must be on ppromiscious mode
aptitude install fprobe

#RESTART ALL SERVICES
/etc/init.d/nfsen reload && /etc/init.d/nfsen reconfig && /etc/init.d/nfsen stop && /etc/init.d/apache2 restart && /etc/init.d/nfsen start && /etc/init.d/fprobe start


