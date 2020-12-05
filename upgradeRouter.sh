#upgrade router firmware
githubLatest=$(curl -so- https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/latestVersion)
luciVersion=$(cat ./latestVersion)
echo --------
echo $(date)
echo githubLatest==localVersion, no need to update
[ $githubLatest = $luciVersion ] && exit
wget https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/firmware/snap/$githubLatest -O ./firmware/snap/$githubLatest
echo $githubLatest > ./latestVersion

#update firmware
scp ./firmware/snap/$githubLatest root@192.168.0.1:/tmp
ssh root@192.168.0.1 sysupgrade -v /tmp/$githubLatest