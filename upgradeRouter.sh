#upgrade router firmware
githubLatest=$(curl -so- https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/latestVersion)
luciVersion=$(cat ./latestVersion)
echo $githubLatest $luciVersion
[ $githubLatest = $luciVersion ] && exit
wget https://github.com/defead/xiaomi4ag-RouterSnap/blob/main/firmware/snap/$githubLatest -O ./firmware/snap/$githubLatest
echo $githubLatest > ./latestVersion
scp ./firmware/snap/$githubLatest root@192.168.0.1:/tmp
ssh root@192.168.0.1 sysupgrade -v /tmp/$githubLatest
