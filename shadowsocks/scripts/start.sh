#!/system/bin/sh

MODDIR=${0%/*}

start_proxy () {
  ${MODDIR}/shadowsocks.service start &> /data/shadowsocks/run/service.log && \
  ${MODDIR}/overture.service start &> /data/shadowsocks/overture/run/service.log && \
  if [ -f /data/shadowsocks/appid.list ] || [ -f /data/shadowsocks/softap.list ] ; then
    ${MODDIR}/shadowsocks.tproxy enable &>> /data/shadowsocks/run/service.log
  fi
}
if [ ! -f /data/shadowsocks/manual ] ; then
  start_proxy
  inotifyd ${MODDIR}/shadowsocks.inotify ${MODDIR}/.. &>> /data/shadowsocks/run/service.log &
fi
