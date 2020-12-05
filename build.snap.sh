#!/bin/bash
defaultUrl=https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mi-router-4a-gigabit-squashfs-sysupgrade.bin
builderUrl=https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
profileSetting=xiaomi_mi-router-4a-gigabit
targetBin="./bin/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mi-router-4a-gigabit-squashfs-sysupgrade.bin"

# cd the directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

#check version
rm index.html
wget -nv https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/
sLine=$(cat index.html | grep 4a-gigabit-squashfs-sysupgrade.bin)
sTime=$(expr "$sLine" : '.*"d">\(.*\)</td>.*')
sVersion=$(echo $sTime | awk '{printf "%s_%s", $2,$3}')
#sVersion=Dec_2
echo -e '--------\n'$(date)
echo Expected version $sVersion
[ -f ./firmware/snap/${sVersion}.bin ] && {
    echo Version ${sVersion}.bin already exist !
    exit
}

#download default bin
wget $defaultUrl -nvO ./firmware/snap/${sVersion}.bin &
echo [ $sTime ] .bin version >> ./versionDate

#build luci version
rm -r openwrt-imagebuilder-ramips-mt7621.Linux-x86_64*
wget -nv $builderUrl
tar -xf openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
cd openwrt-imagebuilder-ramips-mt7621.Linux-x86_64
make image PROFILE=$profileSetting PACKAGES="luci"
cp $targetBin ../firmware/snap/${sVersion}-luci.bin

cd ..
echo [ $(date) ] luci.bin build >> ./versionDate
echo '--------------' >> ./versionDate

echo ${sVersion}-luci.bin >./latestVersion


#github push
git add .
git commit -am "add version ${sVersion}"
git push