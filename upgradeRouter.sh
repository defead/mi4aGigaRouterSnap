#upgrade router firmware
luciVersion=$(cat ./latestVersion)
scp ./firmware/snap/${luciVersion} root@192.168.0.1:/tmp
ssh root@192.168.0.1 sysupgrade -v /tmp/${luciVersion}
