# RTL8732BS 同时使用 STA/AP 模式

## 编译驱动模块
##### 修改 Makefile 如下部分
`ifeq ($(CONFIG_PLATFORM_ANDROID_X86), y)`
`EXTRA_CFLAGS += -DCONFIG_LITTLE_ENDIAN`
`SUBARCH := $(shell uname -m )`
`ARCH := $(SUBARCH)`
`CROSS_COMPILE := `
`KSRC := /lib/modules/4.1.8-yocto-standard/build/`
`MODULE_NAME :=wlan`

找到这几行，相应修改 ARCH ， CROSS_COMPILE ， KSRC 。
然后
`$ make`
编译得到 wlan.ko

## 加载驱动模块
`# insmod wlan.ko ` 原来如果有请移除
输入 `$ ip link ` 即可看到出现两个网口： wlan0 ， wlan1
任意一个网口都可以做 station 模式，或 ap 模式

## 简单测试模块
##### 开启 STATION 模式
` # ip link set wlan0 up `
` # wpa_passphrase ssid_name wifi_passwd > wifi.conf `
` # wpa_supplicant -D wext -i wlan0 -c wifi.conf -B `
` # dhclient wlan0 ` (will take a while )
` # ip addr ` * wlan0 已经获取到 ip *
##### 同时开启 AP 模式
` # ip link set wlan1 up `
` # ip a add 10.0.0.1/24 dev wlan1 `
` # killall dnsmasq && cp egg_wifi/dnsmasq.conf /etc && dnsmasq  `
` # ./hostapd egg_wifi/hostapd.conf & ` **使用给出的hostapd，配置文件可自行修改**
将会放出 SSID 为 mark 的 wifi 热点，如果连接该热点无法获取 ip ，可能是 dnsmasq 的问题，可使用 dhcpd。
