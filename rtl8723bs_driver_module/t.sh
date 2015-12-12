#!/bin/bash

rmmod wlan > /dev/null 2>&1
rmmod rtl8723bs > /dev/null 2>&1

insmod wlan.ko

exit 0
