#!/bin/bash
echo -e "\033[1;32m[+]Compiling libimobiledevice"

function linux_depends(){

        if [[ $(which apt-get) ]]; then
                sudo apt-get install -y git build-essential make autoconf \
                automake libtool openssl tar perl binutils gcc g++ \
                libc6-dev libssl-dev libusb-1.0-0-dev \
                libcurl4-gnutls-dev fuse libxml2-dev \
                libgcc1 libreadline-dev libglib2.0-dev libzip-dev \
                libclutter-1.0-dev ifuse  \
                libfuse-dev cython python2.7 \
                libncurses5 libusbmuxd-dev usbmuxd libplist++-dev libplist-utils \
                libplist-dev libimobiledevice-dev ideviceinstaller libusb-dev \
                zip unzip libimobiledevice-utils libgcrypt20-doc gnutls-doc \
                gnutls-bin git libplist++ python2.7-dev \
                python3-dev libusbmuxd4 libreadline6-dev libusb-dev \
                libzip-dev libssl-dev sshpass m4 bsdiff qemu uml-utilities virt-manager dmg2img git wget libguestfs-tools
                sudo apt-get build-dep
                
        else
                echo "Package manager is not supported"
                exit 1
        fi
}
 
function macos_depends(){
        # Install Hombrew.
        if [[ ! -e $(which brew) ]]; then
                echo "Brew is not installed..."
                echo "installing brew..."
                sleep 1
                ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        else
                echo "Brew already installed"
        fi
	
        # Ask for the administrator password upfront.
        sudo -v

        # Keep-alive: update existing `sudo` time stamp until the script has finished.
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

        # Make sure we’re using the latest Homebrew.
        brew update

        # Upgrade any already-installed formulae.
        brew upgrade

	# Install Development Packages;
        brew install libxml2
        brew install libzip
        brew install libplist
        brew install usbmuxd

        # Install Software;
        brew install automake
        brew install cmake
        brew install colormake
        brew install autoconf
        brew install libtool
        brew install pkg-config
        brew install gcc
        brew install libusb
        brew install glib

        # Install Optional;
        brew install Caskroom/cask/osxfuse

        
        # Install other useful binaries.
        brew install ack
        brew install git

        # Remove outdated versions from the cellar.
        brew cleanup
	
	# OpenSSL shit
	git clone https://github.com/openssl/openssl.git
        cd openssl
 	./config
	make && sudo make install
	cd ..
	rm -rf openssl # clean
}

function build_libimobiledevice(){
       mkdir build
       cd build
        libs=( "libplist" "libusbmuxd" "usbmuxd" "libirecovery" \
                "ideviceinstaller" "libideviceactivation" "idevicerestore" "ifuse" )

        buildlibs() { 
                 
                for i in "${libs[@]}"
                do
                        echo -e "\033[1;32mFetching $i..."
                        git clone https://github.com/libimobiledevice/${i}.git
                        cd $i
                        echo -e "\033[1;32mConfiguring $i..."
                        ./autogen.sh
                        ./configure
                        echo -e "\033[1;32mBuilding $i..."
                        make && sudo make install
                        echo -e "\033[1;32mInstalling $i..."
                        cd ..
                  
                done 
                git clone http://github.com/s0uthwest/libimobiledevice.git
                        cd libimobiledevice
                        echo -e "\033[1;32mConfiguring $i..."
                        ./autogen.sh
                        ./configure
                        echo -e "\033[1;32mBuilding $i..."
                        make
                        
                         echo -e "\033[1;32mInstalling $i..."
                        sudo make install
                        cd ..
                
        }

        buildlibs
        if [[ -e $(which ldconfig) ]]; then
        	ldconfig
        else 
        	echo " "
        fi
}

if [[ $(uname) == 'Linux' ]]; then
        linux_depends
elif [[ $(uname) == 'Darwin' ]]; then
        macos_depends
fi
build_libimobiledevice
	sudo ldconfig
echo -e "\033[1;32m[+]Libimobiledevice successfully installed thanks for using this script"
