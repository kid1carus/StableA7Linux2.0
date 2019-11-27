#!/bin/bash

#$0 <exec> $device <ipsw> 

 sudo ip tuntap add dev tap0 mode tap
 sudo ip link set tap0 up promisc on
 sudo ip link set dev virbr0 up
 sudo ip link set dev tap0 master virbr0	
 sudo virsh net-autostart default
  	
		if [ "$#" == 1 ]; then
		if [ -e "ipwndfu_public" ]; then
			cd ipwndfu_public && git pull origin master
			cd ..
		else
			git clone https://github.com/LinusHenze/ipwndfu_public
		fi

        cd ipwndfu_public
        until [ $string = 1 ];
        do
            
    
			 echo -e "\033[1;32m[+]The script will run ipwndfu again and again until the device is in PWNDFU mode"
			
            read -p "[+]Please put your idevice in dfu mode and press enter"
            ./ipwndfu -p &> /dev/null
            ./ipwndfu -p &> /dev/null
            string=$(lsusb | grep -c "Apple, Inc. Mobile Device (DFU Mode)")
        done
        
        sleep 3
        read -p "[+]Please unplug and plug in your idevice again and press enter"
        ./ipwndfu -p
        python rmsigchks.py
        cd ..
        
		if [ $string == 1 ]; then
			echo "We seem to be in pwned DFU mode!"
                      
			
            
			rm -rfv ipsw  *.im4p *.prepatched *.raw *.img4 shsh iBSS* iBEC* *.bbfw *.im4p downgrade ipsw downgrade.ipsw
			mkdir -p ipsw
			mkdir -p shsh
			unzip -q -d ipsw *.ipsw
			cp -rv ipsw/Firmware/Mav7Mav8-7.60.00.Release.bbfw .
                       
            
            igetnonce | grep 'n53ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPhone6,2"
               echo $device
            fi

            igetnonce | grep 'n51ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPhone6,1"
               echo $device
            fi

            igetnonce | grep 'j71ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPad4,1"
               echo $device
            fi

            igetnonce | grep 'j72ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPad4,2"
               echo $device
            fi

            igetnonce | grep 'j85ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPad4,4"
               echo $device
            fi

            igetnonce | grep 'j86ap' &> /dev/null
            if [ $? == 0 ]; then
               echo "Supported Device"
               device="iPad4,5"
               echo $device
            fi

            if [ -z "$device" ]
            then
                echo "Either unsupported device or no device found."
                echo "Exiting.."
                exit
            else
                echo "Supported device found."
            fi

            #Credit to @dora2_yururi for ECID/Apnonce getting stuff from Nudaoaddu

            ret=$(igetnonce 2>/dev/null | grep ECID)
            ecidhex=$(echo $ret | cut -d '=' -f 2 )
            ecidhex2=$(echo $ecidhex | tr '[:lower:]' '[:upper:]')
            echo $ecidhex2 >/dev/null
            igetnonce
            read -p "[+]Copy and paste ecid and press enter: " ecid
            echo $ecid

			if [ $device == iPhone6,1 ] || [ $device == iPhone6,2 ]; then # If iPhone 5S
				mv -v ipsw/Firmware/dfu/*.iphone6*.im4p .

				if [ $device == iPhone6,1 ]; then
					cp -rv ipsw/Firmware/all_flash/sep-firmware.n51.RELEASE.im4p .
				else
					cp -rv ipsw/Firmware/all_flash/sep-firmware.n53.RELEASE.im4p .
				fi
                bspatch iBSS.iphone6.RELEASE.im4p iBSS.img4 patch/ibss_iphone6.patch
                bspatch iBEC.iphone6.RELEASE.im4p iBEC.img4 patch/ibec_iphone6.patch
				cp -v iBSS.img4 ipsw/Firmware/dfu/iBSS.iphone6.RELEASE.im4p
				cp -v iBEC.img4 ipsw/Firmware/dfu/iBEC.iphone6.RELEASE.im4p
			fi

			if [ $device == iPad4,1 ] || [ $device == iPad4,2 ] || [ $device == iPad4,3 ]; then # If iPad Air
				mv -v ipsw/Firmware/dfu/iBEC.ipad4.RELEASE.im4p .
                mv -v ipsw/Firmware/dfu/iBSS.ipad4.RELEASE.im4p .

				if [ $device == iPad4,1 ]; then
					cp -rv ipsw/Firmware/all_flash/sep-firmware.j71.RELEASE.im4p .
				fi

				if [ $device == iPad4,2 ]; then
					cp -rv ipsw/Firmware/all_flash/sep-firmware.j72.RELEASE.im4p .
				fi 

				if [ $device == iPad4,3 ]; then
					cp -rv ipsw/Firmware/all_flash/sep-firmware.j73.RELEASE.im4p .
				fi 

			   bspatch iBSS.ipad4.RELEASE.im4p iBSS.img4 patch/ibss_ipad4.patch
                bspatch iBEC.ipad4.RELEASE.im4p iBEC.img4 patch/ibec_ipad4.patch

                if [ $device == iPad4,3 ]; then
                    tsschecker -d "$device" --boardconfig j73AP -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid -s --save-path shsh
                fi
                if [ $device = iPad4,1 ] || [ $device = iPad4,2 ]; then
                    tsschecker -d "$device" -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid -s --save-path shsh
                fi

				mv -v shsh/*.shsh2 shsh/stitch.shsh2 
				cp -v iBEC.img4 ipsw/Firmware/dfu/iBEC.ipad4.RELEASE.im4p
                cp -v iBSS.img4 ipsw/Firmware/dfu/iBSS.ipad4.RELEASE.im4p
			fi

			if [ $device == iPad4,4 ] || [ $device == iPad4,5 ]; then # If iPad Mini 2
				mv -v ipsw/Firmware/dfu/iBEC.ipad4b.RELEASE.im4p .
                mv -v ipsw/Firmware/dfu/iBSS.ipad4b.RELEASE.im4p .

				if [ $device == iPad4,4 ]; then
					cp -rv ipsw/Firmware/all_flash/sep-firmware.j85.RELEASE.im4p .
				else
					cp -rv ipsw/Firmware/all_flash/sep-firmware.j86.RELEASE.im4p .
				fi

				bspatch iBSS.ipad4b.RELEASE.im4p iBSS.img4 patch/ibss_ipad4b.patch
                bspatch iBEC.ipad4b.RELEASE.im4p iBEC.img4 patch/ibec_ipad4b.patch
                tsschecker -d "$device" -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid -s --save-path shsh
				mv -v shsh/*.shsh2 shsh/stitch.shsh2 
				
				cp -v iBEC.img4 ipsw/Firmware/dfu/iBEC.ipad4b.RELEASE.im4p
                
                cp -v iBSS.img4 ipsw/Firmware/dfu/iBSS.ipad4b.RELEASE.im4p
			fi

			cd ipsw
            zip -q ../downgrade.ipsw -r0 *
			
			cd ..
			
			raw=$(irecovery -q | grep NONC)
			apnonce=$(echo $raw)

             igetnonce
            read -p "[+]Copy and paste apnonce and press enter: " apnonce
            read -p "[+]Copy and paste your idevice example and press enter 'iPhone6,2': " device
            echo $ecid            
            if [ $device == iPad4,1 ] || [ $device == iPad4,2 ] || [ $device == iPad4,3 ] || [ $device == iPad4,4 ] || [ $device == iPad4,5 ]; then
                
                irecovery -f iBSS.img4
                sleep 2
                irecovery -f iBEC.img4
                sleep 2

                if [ $device == iPad4,3 ]; then
                    tsschecker -d "$device" --boardconfig j73AP -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid --apnonce $apnonce -s
                else
                    tsschecker -d "$device" -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid --apnonce $apnonce -s
                fi
            fi

            if [ $device == iPhone6,1 ] || [ $device == iPhone6,2 ]; then
                
                irecovery -f iBSS.img4
                sleep 2
                irecovery -f iBEC.img4
                sleep 2
                tsschecker -d "$device" -i 10.3.3 -o -m manifests/BuildManifest_"$device"_1033_OTA.plist -e $ecid --apnonce $apnonce -s
            fi

           mv -v *.shsh shsh/apnonce.shsh
            echo "Done prepping files! Time to downgrade!!!"

            echo "****RESTORING!****"
            echo "Waiting for device to reconnect..."
            sleep 10
            if [ $device == iPhone6,1 ] || [ $device == iPhone6,2 ] || [ $device == iPad4,5 ] || [ $device == iPad4,2 ] || [ $device == iPad4,3 ]; then
            
                futurerestore -t shsh/apnonce.shsh -s sep-firmware.*.RELEASE.im4p -m manifests/BuildManifest_"$device"_1033_OTA.plist -b Mav7Mav8-7.60.00.Release.bbfw -p manifests/BuildManifest_"$device"_1033_OTA.plist downgrade.ipsw
                
            fi
            if  [ $device == iPad4,4 ] || [ $device == iPad4,1 ]; then
            
                futurerestore -t shsh/apnonce.shsh -s sep-firmware.*.RELEASE.im4p -m manifests/BuildManifest_"$device"_1033_OTA.plist --no-baseband downgrade.ipsw
            fi
            echo "Cleaning up :D"
            
            echo "If you see this, we're done! Shoutout to the devs and LukeDev for making this possible! - twilightmoon4"
          

        else
            echo "Did not find checkm8 within lsusb. We are going to exit. Please enter pwned DFU and run again!"
            exit
        fi
    fi
    echo "Usage: $0 PathToIpsw (ipsw must be in this directory)"
    echo "Example: $0 iPhone_4.0_64bit_10.3.3_14G60_Restore.ipsw"


