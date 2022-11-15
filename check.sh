#!/bin/sh

## Setting
AIRPORT_DIR="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources"
logFile="/Library/Logs/TechSupport/WiFi-Encrypt-Check/check.log"
mkdir -p /Library/Logs/TechSupport/WiFi-Encrypt-Check/
touch ${logFile}

## wifi on or off check
WIFI_CHECK=`${AIRPORT_DIR}/airport -I | grep "running" | awk '{print $2}'`

if [[ ${WIFI_CHECK} != "running" ]]; then
	echo "$(date)" "WiFi is OFF" >> "$logFile"
	exit 0
fi

## wifi encrypt check
WIFI_ENCRYPT=`${AIRPORT_DIR}/airport -I | grep "link" | awk '{print $3}'`
#WIFI_ENCRYPT="wep"

if [[ ${WIFI_ENCRYPT} = "wpa2"* ]] || [[ ${WIFI_ENCRYPT} = "wpa3"* ]] ; then
	## if wpa2, wpa3
	echo "$(date)" "WiFi is safety! reason:${WIFI_ENCRYPT}" >> "$logFile"
else
	## if another(e.g. wep)
	user=$(ls -la /dev/console | cut -d " " -f 4)

	## display alert window
	userPrompt=$(sudo -u ${user} osascript -e '
		display dialog "あなたの接続しているWiFiは危険です！" buttons {"OK"} default button 1 with title "WiFi Check"
		set tmp to result
		set btn to button returned of tmp
	')
	echo "$(date)" "WiFi is danger! reason:${WIFI_ENCRYPT}" >> "$logFile"
fi

exit 0