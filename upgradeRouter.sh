#!/bin/bash
# cd the directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd $DIR

#upgrade router firmware
githubLatest=$(curl -so- https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/latestVersion)
luciVersion=$(cat ./latestVersion)
#echo --------
[ $githubLatest = $luciVersion ] && {
    echo $(date '+%F %T') "[ Latest: ${githubLatest} ] No need to update!"
    exit
}

echo --------
echo $(date '+%F %T') "Upgrading begins..."

#wget https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/firmware/snap/$githubLatest -O ./firmware/snap/$githubLatest
#echo $githubLatest >./latestVersion
git pull

#update firmware
scp ./firmware/snap/$githubLatest root@192.168.0.1:/tmp
ssh root@192.168.0.1 sysupgrade -v /tmp/$githubLatest

echo $(date '+%F %T') "Upgrading finishes..."
echo --------
