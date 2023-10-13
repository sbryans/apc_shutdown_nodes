# Shutdown & wake slave nodes below a master node using APC status values
Written in BASH, this script allows you to safely shutdown machine nodes below a master node. 
The master node can also send a magic packet to wake machines in its scope.

> It's worth noting that this script makes a fair amount of assumptions. It assumes your master node is configured to send emails & in this case, sending emails via the /usr/local/bin/mail.php executable. Also, there is an assumption that your master node has **[apcupsd]([url](https://command-not-found.com/apcaccess))** installed to check the status of the APC unit connected to the master control node.


## How to check slave hardware for WOL capabilities:
1. Determine if [WOL](https://command-not-found.com/wol) is available on the slave.
> There are plenty of ways to check if WOL is available on your NIC.
Always check your hardware.

```lshw```

```ethtool eth0```

2. Install [etherwake](https://command-not-found.com/etherwake) or [wakeonlan](https://command-not-found.com/wakeonlan) on the master control node.
> Etherwake is just a shell script wrapper around netcat. We'll use it to send a _magic packet_ to our taget machine (slave) from the master control node. You may instead choose to install [wakeonlan](https://command-not-found.com/wakeonlan).

```etherwake```

```wakeonlan```

