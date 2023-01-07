#!/bin/sh

######SYSTEM######
    devices=( $(adb devices | grep -v 'List' | cut -f1) )
##################

# Display menu
echo "Menu:"
echo "================================================================"
echo "1. Install iProxy on phone (assets should be downloaded)"
echo "2. Download and update assets "
echo "3. Run SCRCPY"
echo "4. Exit"
echo "================================================================\n"

# Prompt user to select an option
read -p "Enter your choice: " choice


# Process user's choice
case $choice in
    1)
        # Code for option 1
        if [ "${#devices[@]}" -gt 0 ]
        then
            for device in "${devices[@]}"; do
				        printf "Processing: %s\n" "$device"
                adb -s "$device"  shell settings put global stay_on_while_plugged_in 0
				        adb -s "$device" shell settings put global wfc_ims_enabled 0

				        adb -s "$device" uninstall com.iproxy.android
				        adb -s "$device" install -r iproxy-app.apk
				        adb -s "$device" install -r ovpn.apk

                adb -s "$device" shell settings put secure assist_intent_service_component com.iproxy.android/com.iproxy.android.service.voice.IproxyVoiceInteractionService 
            done

            for device in "${devices[@]}"; do
                scrcpy -s "$device"  --stay-awake  &
            done
        else
            echo "No devices connected."
        fi


				;;
    2)
        # Code for option 2
        curl -O -L https://iproxy.online/android-iproxy-app/latest/assets/iproxy-app.apk 
        curl -O -L http://iproxy.online/android-ovpn-app/ovpn.apk
        ;;
    3)
        # Code for option 3
        if [ "${#devices[@]}" -gt 0 ]
        then
            for device in "${devices[@]}"; do
                scrcpy -s "$device" --stay-awake &
            done
        else
            echo "No devices connected."
        fi

        #scrcpy
				;;
    4)
        # Exit the script
        exit
        ;;
    *)
        # Invalid choice
        echo "Invalid choice"
        ;;
esac



