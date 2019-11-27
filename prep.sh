echo -e "\033[1;32m[+]Grabbing dependencies and installing!"
  cd build
                git clone https://github.com/lzfse/lzfse.git
				git clone https://github.com/tihmstar/libfragmentzip.git
				git clone https://github.com/tihmstar/libgeneral.git
				git clone https://github.com/s0uthwest/idevicerestore.git
				git clone https://github.com/merculous/futurerestore.git
				git clone https://github.com/s0uthwest/img4tool.git
				git clone https://github.com/tihmstar/tsschecker.git
                git clone https://github.com/tihmstar/igetnonce.git


				export PKG_CONFIG_PATH="/usr/local/opt/openssl/lib/pkgconfig"

			       cd lzfse
                              git submodule init 
                            git submodule update
                             
				./autogen.sh
				./configure
				make 
                                sudo make install
				cd ..
                                cd libgeneral
                           git submodule init
                         git submodule update
                          
				./autogen.sh
				./configure
				make
                                  sudo make install
				cd ..
                                cd libfragmentzip
                           git submodule init
                          git submodule update
                            
				./autogen.sh
				./configure
				make 
                              sudo make install
				cd ..
				        cd idevicerestore
                           git submodule init
                          git submodule update
                            
				./autogen.sh
				./configure
				make 
                              sudo make install
				cd ..
                               cd futurerestore
                           git submodule init 
                           git submodule update
                           cd external
                           rmdir idevicerestore
                           rmdir tsschecker
                           rmdir img4tool
                           git clone https://github.com/s0uthwest/idevicerestore.git
                           git clone https://github.com/s0uthwest/tsschecker.git
                           git clone https://github.com/s0uthwest/img4tool.git
                           cd tsschecker
                           cd external
                        rmdir jssy
                        git clone https://github.com/tihmstar/jssy.git
                           cd ..
                           cd ..
                           
                           cd ..
				./autogen.sh
				./configure
				make && sudo make install
				cd .. 
                               cd img4tool
                          git submodule init 
                       git submodule update
                        
				./autogen.sh
				./configure
				make           
                                sudo make install
				cd ..
                                cd tsschecker
                            git submodule init
                        git submodule update
                        cd external
                        rmdir jssy
                        git clone https://github.com/tihmstar/jssy.git
                         cd ..
				./autogen.sh
				./configure
				make
                                sudo make install
                               cd .. 
                              cd igetnonce
                           git submodule init
                     git submodule update
				./autogen.sh
				./configure
				make 
                               sudo make install
                            cd ..
                            cd ..
                              
                              unzip -o manifests.zip
                              unzip -o maloader.zip
                              unzip -o liboffsetfinder64.zip
                              cd liboffsetfinder64
				./autogen.sh
				./configure
				make 
                               sudo make install
                               cd ..
                               cd maloader 
                                make release

                         cd ..
                 sudo apt-get install libcurl4-openssl-dev
             echo "\033[1;32m[+]Downloading patches..."
wget -O patch.zip https://gitlab.com/devluke/stablea7/-/archive/master/stablea7-master.zip?path=patch -q --show-progress
unzip -o patch.zip
cp -r stablea7-master-patch/patch .


                 
				echo -e "\033[1;32m[+]Dependencies should now be installed and compiled."
