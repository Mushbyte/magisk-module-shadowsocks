#!/sbin/sh
#####################
# V2ray Customization
#####################
SKIPUNZIP=1

# prepare shadowsocks execute environment
ui_print "- Prepare shadowsocks-rust execute environment."
mkdir -p /data/shadowsocks
mkdir -p /data/shadowsocks/run
mkdir -p /data/shadowsocks/overture
mkdir -p /data/shadowsocks/overture/run
mkdir -p $MODPATH/scripts
mkdir -p $MODPATH/system/bin
# download latest shadowsocks core from official link
ui_print "- Connect official shadowsocks-rust download link."
official_shadowsocks_link="https://github.com/Mushbyte/magisk-module-shadowsocks/releases/download/v0.1-alpha"
download_shadowsocks_link="${official_shadowsocks_link}/shadowsocks.zip"
download_shadowsocks_zip="/data/shadowsocks/run/shadowsocks.zip"
curl "${download_shadowsocks_link}" -k -L -o "${download_shadowsocks_zip}" >&2
if [ "$?" != "0" ] ; then
  ui_print "Error: Download shadowsocks-rust core failed."
  exit 1
fi
# install shadowsocks execute file
ui_print "- Install shadowsocks-rust core $ARCH execute files"
unzip -j -o "${download_shadowsocks_zip}" "config_example.json" -d /data/shadowsocks >&2
unzip -j -o "${download_shadowsocks_zip}" "overture/*" -d /data/shadowsocks/overture >&2
unzip -j -o "${download_shadowsocks_zip}" "v2ray-plugin" -d $MODPATH/system/bin >&2
unzip -j -o "${download_shadowsocks_zip}" "sslocal" -d $MODPATH/system/bin >&2
unzip -j -o "${download_shadowsocks_zip}" "ss-rules" -d $MODPATH/system/bin >&2
unzip -j -o "${download_shadowsocks_zip}" "run_overture" -d $MODPATH/system/bin >&2
unzip -j -o "${ZIPFILE}" 'shadowsocks/scripts/*' -d $MODPATH/scripts >&2
unzip -j -o "${ZIPFILE}" 'service.sh' -d $MODPATH >&2
unzip -j -o "${ZIPFILE}" 'uninstall.sh' -d $MODPATH >&2
rm "${download_shadowsocks_zip}"
# copy shadowsocks data and config
ui_print "- Copy shadowsocks-rust config and data files"
[ -f /data/shadowsocks/softap.list ] || \
echo "192.168.43.0/24" > /data/shadowsocks/softap.list
[ -f /data/shadowsocks/appid.list ] || \
echo "0" > /data/shadowsocks/appid.list
# generate module.prop
ui_print "- Generate module.prop"
rm -rf $MODPATH/module.prop
touch $MODPATH/module.prop
echo "id=shadowsocks" > $MODPATH/module.prop
echo "name=shadowsocks for Android" >> $MODPATH/module.prop
echo -n "version=" >> $MODPATH/module.prop
echo "0.1" >> $MODPATH/module.prop
echo "versionCode=20210402" >> $MODPATH/module.prop
echo "author=stone" >> $MODPATH/module.prop
echo "description=shadowsocks-rust core with service scripts for Android" >> $MODPATH/module.prop

inet_uid="3003"
net_raw_uid="3004"
set_perm_recursive $MODPATH 0 0 0755 0644
set_perm  $MODPATH/service.sh    0  0  0755
set_perm  $MODPATH/uninstall.sh    0  0  0755
set_perm  $MODPATH/scripts/start.sh    0  0  0755
set_perm  $MODPATH/scripts/shadowsocks.inotify    0  0  0755
set_perm  $MODPATH/scripts/shadowsocks.service    0  0  0755
set_perm  $MODPATH/scripts/shadowsocks.tproxy     0  0  0755
set_perm  $MODPATH/system/bin/sslocal  ${inet_uid}  ${inet_uid}  0755
set_perm  /data/shadowsocks ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/system/bin/v2ray-plugin  ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/system/bin/ss-rules  ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/system/bin/run_overture  ${inet_uid}  ${inet_uid}  0755
set_perm  $MODPATH/scripts/overture.service    0  0  0755
