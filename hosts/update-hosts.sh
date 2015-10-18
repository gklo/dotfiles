#!/bin/sh

# remove existing hosts file
rm -f hosts
wget http://someonewhocares.org/hosts/zero/hosts

# associcate localhost6 with ::1
echo "Adding localhost6 ..."
sed -i '/^\:\:1/ s/$/ localhost6/g' hosts

# process whitelist
echo "Processing whitelist ..."
if [ -e whitelist ]; then
  while read line ; do
    [ ! ${line:0:1} == "#" ] && sed -i "/${line}/ s/^/#/g" hosts
  done < whitelist
fi

# replace the system hosts
echo "Replacing the system hosts file ..."
sudo cp hosts /etc/hosts
