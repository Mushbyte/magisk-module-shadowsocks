# Shadowsocks Magisk Module

This is a shadowsocks module for Magisk, adapted from [magisk-module-installer](https://github.com/topjohnwu/magisk-module-installer). The module should work for arm64 (android 7.0+).

## Included

* [shadowsocks-rust](<https://github.com/shadowsocks/shadowsocks-rust>)
* [overture](<https://github.com/shawn1m/overture>)
* [v2ray-plugin](<https://github.com/shadowsocks/v2ray-plugin>)
* [ss-rules](<https://github.com/shadowsocks/luci-app-shadowsocks/blob/master/files/root/usr/bin/ss-rules-without-ipset>)
* [china_ip_list](https://github.com/17mon/china_ip_list)

- shadowsocks-rust service script and Android transparent proxy iptables script, adapted from [magisk-module-installer](https://github.com/topjohnwu/magisk-module-installer)



## Install

You can download the release installer zip file and install it via the Magisk Manager App.

**The script `customize.sh` in the installer will download binaries from github that are compiled by myself. When you choose to install the module, you do so at your own risk.**

## Config

- shadowsocks-rust config file is store in `/data/shadowsocks/config.json` .

- Please make sure the config is correct.

- overture config file is store in `/data/shadowsocks/overture/` folder. Stronly recommend to deploy a doh server on the shadowsocks server side, such as [dns-over-https](<https://github.com/m13253/dns-over-https>), and use it as the dns upstream server to replace the default cloudflare doh server in the file `/data/shadowsocks/overture/config.yml`. 

- Tips: Please notice that the default configuration has been set to cooperate with the transparent proxy script. Modify `/data/shadowsocks/appid.list` to select which App to proxy.


## Usage

### Normal usage ( Default and Recommended )

#### Manage service start / stop

- shadowsocks-rust and overture service is auto-run after system boot up by default.
- You can stop or start shadowsocks service by simply turn off or turn off the module via Magisk Manager App. 
- It should be noted that stop shadowsocks service will delete some iptables rules for transparent proxy, but the deleted iptable rules will not be added after the shadowsocks service (re)start.


#### Select which App to proxy

- If you expect transparent proxy ( read Transparent proxy section for more detail ) for specific Apps, just write down these Apps' uid in file `/data/shadowsocks/appid.list` . 

  Each App's uid should separate by space or just one App's uid per line. ( for Android App's uid , you can search App's package name in file `/data/system/packages.list` , or you can look into some App like Shadowsocks. )

- If you expect all Apps proxy by shadowsocks-rust with transparent proxy, just write a single number `0` in file `/data/shadowsocks/appid.list` .

- If you expect all Apps proxy by shadowsocks-rust with transparent proxy EXCEPT specific Apps, write down `#bypass` at the first line then these Apps' uid separated as above in file `/data/shadowsocks/appid.list`. 

- Transparent proxy won't take effect until the shadowsocks-rust service start normally and file `/data/shadowsocks/appid.list` is not empty.


#### Share transparent proxy to WiFi guest or USB guest

(**It has not been tested**)

- Transparent proxy is share to WiFi guest by default.
- If you don't want to share proxy to WiFi guest or USB guest, delete the file `/data/shadowsocks/softap.list` or empty it.
- For most situation, Android WiFi hotspot subnet is `192.168.43.0/24`, and USB subnet is `192.168.42.0/24`. If your device is not conform to it , please write down the subnet you want proxy in `/data/shadowsocks/softap.list`. ( You can run command `ip addr` to search the subnet )



### Advanced usage ( for Debug and Develop only )

#### Enter manual mode

If you want to control shadowsocks-rust by running command totally, just add a file `/data/shadowsocks/manual`.  In this situation, shadowsocks-rust service won't start on boot automatically and you cann't manage service start/stop via Magisk Manager App. 



#### Manage service start / stop

- shadowsocks-rust service script is `$MODDIR/scripts/shadowsocks.service`.

- For example, in my environment ( Magisk version: 18100 ; Magisk Manager version v7.1.1 )

  - Start service : 

    `/sbin/.magisk/img/shadowsocks-rust/scripts/shadowsocks.service start`

  - Stop service :

    `/sbin/.magisk/img/shadowsocks-rust/scripts/shadowsocks.service stop`



#### Manage transparent proxy enable / disable

- Transparent proxy script is `$MODDIR/scripts/shadowsocks.tproxy`.

- For example, in my environment ( Magisk version: 18100 ; Magisk Manager version v7.1.1 )

  - Enable Transparent proxy : 

    `/sbin/.magisk/img/shadowsocks-rust/scripts/shadowsocks.tproxy enable`

  - Disable Transparent proxy :

    `/sbin/.magisk/img/shadowsocks-rust/scripts/shadowsocks.tproxy disable`



## Transparent proxy

### What is "Transparent proxy"

> "A 'transparent proxy' is a proxy that does not modify the request or response beyond what is required for proxy authentication and identification". "A 'non-transparent proxy' is a proxy that modifies the request or response in order to provide some added service to the user agent, such as group annotation services, media type transformation, protocol reduction, or anonymity filtering".
>
> ​                                -- [Transparent proxy explanation in Wikipedia](https://en.wikipedia.org/wiki/Proxy_server#Transparent_proxy)



### Working principle

This module also contains a simple script that helping you to make transparent proxy via iptables. In fact , the script is just make some REDIRECT and TPROXY rules to redirect app's network into 65535 port in localhost. And 65535 port is listen by shadowsocks inbond with dokodemo-door protocol. In summarize, the App proxy network path is looks like :



**Android App** ( Google, Facebook, Twitter ... )

  &vArr;  ( TCP & UDP network protocol )

Android system **iptables**      [ localhost inside ]

  &vArr;  ( REDIRECT & TPROXY iptables rules )

[ 127.0.0.1:65535 Inbond ] -- **shadowsocks-rust** -- [ Outbond ]

  &vArr;  ( Shadowsocks )

**Proxy Server** ( SS, shadowsocks-rust)   [ Internet outside ]             

  &vArr; ( HTTP, TCP, ... other application protocol ) 

**App Server** ( Google, Facebook, Twitter ... )



## Uninstall

1. Uninstall the module via Magisk Manager App.
2. You can clean shadowsocks data dir by running command `rm -rf /data/shadowsocks` .



## shadowocks-rust

This is a port of shadowsocks. shadowsocks is a fast tunnel proxy that helps you bypass firewalls.

## overture

Overture is a customized DNS relay server. Overture means an orchestral piece at the beginning of a classical music composition, just like DNS which is nearly the first step of surfing the Internet.

## v2ray-plugin

Yet another SIP003 plugin for shadowsocks, based on v2ray

## License

[GNU General Public License v3.0](https://github.com/shadowsocks/luci-app-shadowsocks/blob/master/LICENSE)
