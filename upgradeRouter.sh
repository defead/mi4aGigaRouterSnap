#!/bin/bash
# cd the directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd $DIR
checkState=false

checkFirmware() {
    luciVersion=$(cat ./latestVersion)
    [ "$1" = "u" ] && {
        checkState=true
        return
    }
    githubLatest=$(curl -so- https://raw.githubusercontent.com/defead/xiaomi4ag-RouterSnap/main/latestVersion)
    [ $githubLatest = $luciVersion ] && {
        echo $(date '+%F %T') "[ Latest: ${githubLatest} ] No need to update!"
        checkState=false
        return
    }
}

updateFirmware() {
    echo --------
    echo $(date '+%F %T') "Upgrading begins..."
    git pull
    scp ./firmware/snap/$luciVersion root@192.168.0.1:/tmp
    ssh root@192.168.0.1 sysupgrade -v /tmp/$luciVersion
    echo $(date '+%F %T') "Upgrading finishes..."
    echo --------
}

main() {
    checkFirmware "$@"
    # $checkState && echo $luciVersion
    $checkState && updateFirmware
}

main "$@"
