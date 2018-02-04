#!/bin/bash
set -eu

################################################
# Script to rebuild all TigerOS RPMs with tito #
# @author: Aidan Kahrs                         #
#                                              #
# Usage: sudo bash ci-build-mock.sh            #
#                                              #
################################################
#Check that the current user is root
#if [ $EUID != 0 ]
#then
 #   echo "Please run this script as root (sudo $@$0)."
  #  exit
#fi
cd sources/
for dir in $(find ~/TigerOS/sources -name '*.spec' -printf '%h\n' | sort -u)
do
    cd "$dir"
    tito build --rpm --test --output=/home/build/to-sign/ --builder mock --arg  mock=fedora-26-x86_64
done
echo "Build finished"

