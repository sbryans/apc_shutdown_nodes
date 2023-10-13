# Shutdown & wake slave nodes below a master node using APC status values
Written in BASH, this script allows you to safely shutdown machine nodes below a master node. 
The master node can also send a magic packet to wake machines in its scope.

> It's worth noting that this script makes a fair amount of assumptions. It assumes your master node is configured to send emails & in this case, sending emails via the /usr/local/bin/mail.php executable. Also, there is an assumption that your master node has **[apcupsd]([url](https://command-not-found.com/apcaccess))** installed to check the status of the APC unit connected to the master control node. In addition to the other assumptions I've made; your master control node must be able to ssh into the slave to commence shutdown of said machine. Remote root access is not best practice, so shell-style wildcards will be necessary.

```nano /etc/sudoers```

Add the following at the bottom of the file replacing **non_root_user_name** with the user that allows the master control node ssh access.

```non_root_user_name ALL = NOPASSWD: /sbin/shutdown```

## How to check the slave hardware for WOL capabilities:
1. Determine if [WOL](https://command-not-found.com/wol) is available on the slave.
> There are plenty of ways to check if WOL is available on your NIC.
Always check your hardware.

```lshw```

```ethtool eth0```

2. Install [etherwake](https://command-not-found.com/etherwake) or [wakeonlan](https://command-not-found.com/wakeonlan) on the master control node.
> Etherwake is just a shell script wrapper around netcat. We'll use it to send a _magic packet_ to our target machine (slave) from the master control node. You may instead choose to install [wakeonlan](https://command-not-found.com/wakeonlan).

```etherwake```

```wakeonlan```

