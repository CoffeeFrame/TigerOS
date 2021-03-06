#!/bin/bash
set -eu

#################################################################################
# TigerOS Build Script(source iso) for running on the build box with Jenkins CI #
# @author: Aidan Kahrs                                                          #
#                                                                               #
# Usage: sudo bash ci-build-mock.sh                                             #
#                                                                               #
#################################################################################

vers=27

# Check that the current user is root
if [ $EUID != 0 ]
then
    echo "Please run this script as root (sudo $@$0)."
    exit
fi
#wget -O tigeros-source.ks https://raw.githubusercontent.com/RITlug/TigerOS/master/tigeros-source.ks
mock --old-chroot -r fedora-$vers-x86_64 --init
mock --old-chroot -r fedora-$vers-x86_64 --copyin kickstarts/tigeros-source.ks ./tigeros-source.ks
mock --old-chroot -r fedora-$vers-x86_64 --install pungi
mock --old-chroot -r fedora-$vers-x86_64 --install
https://builder.ritlug.com/packages/x86_64/anaconda-installclass-tigeros-$vers-1.fc$vers.x86_64.rpm
mock --old-chroot -r fedora-$vers-x86_64 --chroot "pungi -G -c tigeros-source.ks --name=TigerOS --ver $vers --force && pungi -C -c tigeros-source.ks --name=TigerOS --ver=$vers --force && pungi -I -c tigeros-source.ks--name=TigerOS --ver=$vers --sourceisos --force"
rm -rf /var/www/isos/TigerOS-source-$(date +%Y%m%d).iso
mock --old-chroot -r fedora-$vers-x86_64 --copyout /$vers/source/iso/TigerOS-DVD-source-$vers.iso /var/www/isos/TigerOS-source-$(date +%Y%m%d).iso 
rm -rf /var/lib/mock/
cd /var/www/isos
rm -rf CHECKSUM512-source-$(date +%Y%m%d)
sha512sum TigerOS-source-$(date +%Y%m%d).iso > CHECKSUM512-source-$(date +%Y%m%d) 
chown -R nginx:nginx /usr/share/nginx/html
chmod 755 /var/www/isos/*.iso
echo "Pungi finished"

