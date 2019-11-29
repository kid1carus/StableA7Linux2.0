# StableA7Linux for iOS10.3.3
I come here to release you my beta of the StableA7 port for Linux
Warning: apparently doesn't work on ipads (in momments), only iphones
Is downgrade for iOS10.3.3 in A7 idevices
What do you need to install?
- A Ubuntu / Debian based Linux distro (I recommend Lubuntu which I use) , installed, no Live CD
- Patience (very important)
- A brain (very rare)
*Open Software&Updates (or Software Sources depending on your Linux distro or even Additional Drivers) and enable all sources on the Other Software tab
=> just run:
git clone https://github.com/twilightmoon4/StableA7Linux2.0.git
cd StableA7Linux2.0
sudo apt-get update
chmod +x *
sudo bash install.sh (run 2x per warranty)
sudo bash prep.sh (run 2x per warranty)
sudo ldconfig
=> And then place IPSW without renaming in the folder where install.sh and restore.sh
=> run on terminal :
./restore.sh "your idevice"
=> Without quotes
=> Example: iPhone6,2
=> (Warning, the exploit can be very tiring, so be patient)
Okay, after a long time before the exploit works, and congratulations ! your idevice will be on iOS 10.3.3 <3
Thanks to: @LinusHenze @mosk_i @tihmstar @a_i_da_n @ConsoleLogLuke <3
