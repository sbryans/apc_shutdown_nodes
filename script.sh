#!/bin/sh

# Battery output
APCSTATUS=`apcaccess |grep TIMELEFT |awk '{print $3}'`
# Thresholds
THRESHOLD_MASTER=5 # Shutdown control node when APC has 5 minutes of battery left.
THRESHOLD_SLAVE=30 # Shutdown value for slave machine.
WAKE_VALUE=75 # Battery value required before waking machines.
# Machines
MACHINE_NAME=

shutdown_slaves(){
    # Shutdown MACHINE_NAME
    ping -c1 -W1 $MACHINE_NAME && ssh user@${MACHINE_NAME} "sudo /sbin/shutdown" || echo 'MACHINE_NAME is already down...'
    sleep 30
    ping -c1 -W1 $MACHINE_NAME && echo "MACHINE_NAME responding." | /usr/local/bin/mail.php -s"APC UPS detected power failure and shut down MACHINE_NAME."
}

wake_machines(){
    # Wake MACHINE_NAME
    wol xx:xx:xx:xx:xx:xx
}

shutdown_master(){
    # Shutdown Master Control Node
    echo "Shutting down Master Control Node in 10 seconds..."
    sleep 10
    echo "APC UPS fell below threshold. Shutdown sequence in 30 seconds." | /usr/local/bin/mail.php -s"APC UPS detected power failure and shutdown sequence started. Run < shutdown -c > on the node to cancel."
    sleep 30
    /sbin/shutdown
}

# Cast float to int. 
APCSTATUS=$( printf "%.0f" $APCSTATUS )

# Blocks to run if battery level falls below treshold.
[ ${THRESHOLD_SLAVE} -gt ${APCSTATUS} ] && shutdown_slaves || echo "Keep slaves alive."
[ ${THRESHOLD_MASTER} -gt ${APCSTATUS} ] && shutdown_master || echo "Keep master alive."

# Code block to run if battery level raises above WAKE_VALUE.
[ ${APCSTATUS} -gt ${WAKE_VALUE} ] && wake_machines || echo "The battery doesn't have enough charge to wake machines."
