#!/usr/bin/env bash
# Network Testing Appliance
# Uses the speedtest.net servers and SpeedTest-CLI
# SpeedTest-cli by Matt Martz

# Version 1 - Simple Speed Testing
# Installer Script (run as root/sudo please)

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi
  function pause(){
   read -p "$*"
}
 
function pip_install {
   local package_name=$1
   echo "Installing $package_name"
   pip install $package_name 2>&1 >/dev/null
   pip3 install $package_name 2>&1 >/dev/null
}

echo "Welcome to The Network Testing Appliance Installer"
pause 'Press [Enter] to install the required bits and pieces or CTRL+C to stop...'
echo "Installing mpack zip ssmtp mailutils mpack python-pip python3-pip python-spidev python3-spidev"
apt-get install mpack zip ssmtp mailutils mpack python-pip python3-pip python-spidev python3-spidev -y 2>&1 >/dev/null
if [ "$?" -ne 0 ]; then
  echo "Error while running apt-get (maybe run apt-get update?)";
  exit 1;
fi
echo "Done"
echo "Now installing python modules"
pip_install gpiozero
pip_install speedtest-cli
pip_install ipgetter
pip_install statistics
pip_install ascii_graph

#echo "Updating cron for user 'pi'"
#cat <<EOF > /etc/cron.d/speedtest-cron
#SHELL=/bin/sh
#PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin#
#
# m   h dom mon dow user	command
#15,45 *  *   *   *	pi    cd /home/pi/speedtest-cron && ./speedtest.sh
#30    8  *   *   *	pi    cd /home/pi/speedtest-cron && ./doemailout.sh
#35    8  *   *   0	pi    cd /home/pi/speedtest-cron && ./doweeklycleanup.sh
#EOF

echo "All done! Enjoy"
