#!/bin/bash
defaultUrl=https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mi-router-4a-gigabit-squashfs-sysupgrade.bin
builderUrl=https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
profileSetting=xiaomi_mi-router-4a-gigabit
targetBin="./bin/targets/ramips/mt7621/openwrt-ramips-mt7621-xiaomi_mi-router-4a-gigabit-squashfs-sysupgrade.bin"

# cd the directory
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
cd $DIR

#check version
rm index.html
wget -q https://downloads.openwrt.org/snapshots/targets/ramips/mt7621/
sLine=$(cat index.html | grep 4a-gigabit-squashfs-sysupgrade.bin)
sTime=$(expr "$sLine" : '.*"d">\(.*\)</td>.*')
sVersion=$(echo $sTime | awk '{printf "%s_%s", $2,$3}')
#sVersion=Dec_1
echo -e '--------'
echo $(date '+%F %T') Expected version $sVersion
[ -f ./firmware/snap/${sVersion}.bin ] && {
    echo Version ${sVersion}.bin already exist !
    exit
}


git pull

#build luci version
rm -r openwrt-imagebuilder-ramips-mt7621.Linux-x86_64*
echo downloading imagebuilder
wget -nv $builderUrl
tar -xf openwrt-imagebuilder-ramips-mt7621.Linux-x86_64.tar.xz
cd openwrt-imagebuilder-ramips-mt7621.Linux-x86_64
echo building luci version ... output: buildInfo
make image PROFILE=$profileSetting PACKAGES="luci" >>../buildInfo.$sVersion 2>&1
if [ $? -eq 0 ]; then
    echo "Successfully created $sVersion"
else
    echo "luciVersion build failed!!!"
    exit
fi
cp $targetBin ../firmware/snap/${sVersion}-luci.bin

cd ..
#download default bin
wget $defaultUrl -nv -O ./firmware/snap/${sVersion}.bin 

echo [ $sTime ] $sVersion.bin version >>./versionDate
echo [ $(date "+%a %b %e %R:%S %Y") ] $sVersion-luci.bin build >>./versionDate
echo '--------------' >>./versionDate

echo ${sVersion}-luci.bin >./latestVersion

#github push
git add .
git commit -am "add version ${sVersion}"
git push
