#!/bin/sh

AIRPORT_DIR="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources"

## wifi on or off
WIFI_CHECK=`${AIRPORT_DIR}/airport -I | grep "running" | awk '{print $2}'`

if [[ ${WIFI_CHECK} != "running" ]]; then
	echo OFF
	exit 0
fi

## wifi encrypt check
WIFI_ENCRYPT=`${AIRPORT_DIR}/airport -I | grep "link" | awk '{print $3}'`
#WIFI_ENCRYPT="wep"

if [[ ${WIFI_ENCRYPT} = "wpa2"* ]] || [[ ${WIFI_ENCRYPT} = "wpa3"* ]] ; then
	echo "WiFi is OK! reason:${WIFI_ENCRYPT}"
else
	#echo "あなたのネットワークは危険です"
	user=$(ls -la /dev/console | cut -d " " -f 4)

	userPrompt=$(sudo -u ${user} osascript -e '
		display dialog "あなたの接続しているWiFiは危険です！" buttons {"OK"} default button 1 with title "WiFi Check"
		set tmp to result
		set btn to button returned of tmp
	')
	#echo "$userPrompt"
fi

exit 0