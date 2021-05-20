#!/bin/sh

AIRPORT_DIR="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources"
WIFI_ENCRYPT=`${AIRPORT_DIR}/airport -I | grep "link" | awk '{print $3}'`
#echo ${WIFI_ENCRYPT}
WIFI_ENCRYPT="wep"
if [[ ${WIFI_ENCRYPT} = "wpa2"* ]] || [[ ${WIFI_ENCRYPT} = "wpa3"* ]] ; then
	echo OK
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