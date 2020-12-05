#upgrade router firmware
scp ./firmware/snap/${sVersion}-luci.bin root@192.168.0.1:/tmp
ssh root@192.168.0.1 sysupgrade -v /tmp/${sVersion}-luci.bin
