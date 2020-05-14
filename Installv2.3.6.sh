#!/usr/bin/env bash


# Es wird empfohlen nvidia als Benutzer zu verwenden da leider einige Softwarepakete diesen hardcodiert enthalten (können) und man sucht dann lange nach Fehlern
Benutzer="nvidia"


if [ "$(whoami)" != $Benutzer ]; then
        echo $(date -u) "Script muss als Benutzer $Benutzer ausgeführt werden!"
        exit 255
fi

#Debug Modus: -x = an, +x = aus
set +x

# Stopp bei Fehler an (-e)
# Wird vor der Ausführung von eval bashrc ausgeschaltet da Shell-In-Shell return's einen Fehler erzeugen (können) der bei der Installation aber nicht relevant ist
set -e


# Name der virtuellen Umgebung, kann nach persönlichem Geschmack problemlos geändert werden
VirtEnv="tf15cv4"

#Vorbelegung CompilerFlags und Warnungen zu unterdrücken die durch automatisch generierten Code schnell mal entstehen können und keine wirkliche Relevanz haben
export CFLAGS=$CFLAGS" -w"
export CPPFLAGS=$CPPFLAGS" -w"
export CXXFLAGS=$CXXFLAGS" -w"

#Vermeiden von ReadTimeOut bei PIP, falls mal die Verbindung Probleme macht
export PIP_DEFAULT_TIMEOUT=100

echo $(date -u) "Test auf bestehende Installation.log"
                 test -f ~/Installation.log && rm ~/Installation.log

echo $(date -u) "Installation.log anlegen"
                 touch ~/Installation.log

echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "# Objekterkunng mit OpenCV, TensoFlow, Yolov3. By WIEGEHTKI.DE                                                                      #" | tee -a  ~/Installation.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anwenden                                                              #" | tee -a  ~/Installation.log
echo $(date -u) "#                                                                                                                                   #" | tee -a  ~/Installation.log
echo $(date -u) "# V2.3.6, 24.04.2020                                                                                                                #" | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "01 von 29: SUDO - rechte um ohne Passworteingabe zukünftig installieren zu können als root durchgeführt?"  | tee -a  ~/Installation.log
echo $(date -u) "Hier die Befehle dazu:" | tee -a  ~/Installation.log
echo $(date -u) "   sudo su"             | tee -a  ~/Installation.log
echo $(date -u) "   chmod +x *.sh"       | tee -a  ~/Installation.log
echo $(date -u) "   ./nvidia2sudoers.sh" | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "02 von 29: Aktuelle Installationsparameter:"  | tee -a  ~/Installation.log
echo $(date -u) "Benutzer: '$Benutzer'"  | tee -a  ~/Installation.log
echo $(date -u) "Virtual Environment Wrapper: '$VirtEnv'"  | tee -a  ~/Installation.log
echo $(date -u) "Compilerflags: CFLAGS:'$CFLAGS' CPPFLAGS:'$CPPFLAGS' CXXFLAGS:'$CXXFLAGS'"  | tee -a  ~/Installation.log

echo $(date -u) "03 von 29: Systemupdate"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 #sudo apt -y install apt-utils
                 sudo apt -y update
                 sudo apt -y dist-upgrade
                 sudo ldconfig
                 #sudo apt -y autoremove

echo $(date -u) "04 von 29: Swap-File mit 8GB anlegen, aktivieren und kontrollieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install nano
                 sudo fallocate -l 8G /swapfile
                 sudo chmod 600 /swapfile
                 sudo mkswap /swapfile
                 sudo swapon /swapfile
                 sudo swapon --show

echo $(date -u) "05 von 29: Systemwerkzeuge, Editor, Tools"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install git-all doxygen build-essential nghttp2 libnghttp2-dev libssl-dev
                 sudo apt -y install libatlas-base-dev gfortran
                 sudo apt -y install libhdf5-serial-dev hdf5-tools
                 sudo apt -y install python3-dev locate

echo $(date -u) "06 von 29: Pakete für SciPy"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libfreetype6-dev python3-setuptools
                 sudo apt -y install protobuf-compiler libprotobuf-dev openssl
                 sudo apt -y install libcurl4-openssl-dev
                 #sudo apt -y install cython3

echo $(date -u) "07 von 29: XML Tool für Tensorflow API Objekterkennung"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libxml2-dev libxslt1-dev

echo $(date -u) "08 von 29: Pakete für OpenCV incl. Codecs, Image und GUI Bibliotheken"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install pkg-config qt4-dev-tools qt4-qmake
                 sudo apt -y install libtbb2 libtbb-dev libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
                 sudo apt -y install libtiff-dev libjpeg-dev libpng-dev
                 sudo apt -y install python-tk libgtk-3-dev libcanberra-gtk-module libcanberra-gtk3-module

echo $(date -u) "09 von 29: Pakete für die (USB) Kamera"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libdc1394-22-dev libv4l-dev v4l-utils qv4l2 v4l2ucp

echo $(date -u) "10 von 29: WIEGEHTKI Repo-clone"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git

echo $(date -u) "11 von 29: PreCompiler: cmake 3.17.1"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y purge cmake
                 wget http://www.cmake.org/files/v3.17/cmake-3.17.1.tar.gz
                 tar xpvf cmake-3.17.1.tar.gz
                 cd   ~/cmake-3.17.1/
                 ./bootstrap
                 make   -j4

                 echo 'export PATH=/home/'$Benutzer'/cmake-3.17.1/bin/:/home/'$Benutzer'/.local/bin/:$PATH' >> ~/.bashrc
                 export PATH=/home/$Benutzer/cmake-3.17.1/bin/:/home/$Benutzer/.local/bin/:$PATH
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +1)"
                 set -e
                 #sudo apt -y autoremove

echo $(date -u) "12 von 29: Pfadprüfung - Pfad ist gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 echo $PATH  | tee -a  ~/Installation.log

echo $(date -u) "13 von 29: Pythonpakete und Tools"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 wget https://bootstrap.pypa.io/get-pip.py
                 sudo -H python3 get-pip.py
                 rm get-pip.py
                 sudo -H apt -y install python3-pip
                 sudo -H pip3 install -U pip testresources setuptools

echo $(date -u) "14 von 29: Virtuelle Umgebung installieren, anpassen und aktivieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 sudo -H pip3 install virtualenv virtualenvwrapper
                 export WORKON_HOME=$HOME/.virtualenvs
                 export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

                 echo '#virtualenv and virtualenvwrapper' >> ~/.bashrc
                 echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
                 echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
                 echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
                 #source /usr/local/bin/virtualenvwrapper.sh

                 set +e
                 eval "$(cat ~/.bashrc | tail -n +3)"
                 set -e

echo $(date -u) "15 von 29: Environmentprüfung - gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 echo $WORKON_HOME  | tee -a  ~/Installation.log
                 echo $VIRTUALENVWRAPPER_PYTHON  | tee -a  ~/Installation.log

echo $(date -u) "16 von 29: Virtuelle Umgebung bauen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 set +e
                 mkvirtualenv $VirtEnv -p python3
                 workon $VirtEnv
                 set -e
                 cd ~
                 ~/.virtualenvs/$VirtEnv/bin/python -m pip install --upgrade pip

                 echo $(date -u) "16.1 von 29: Erledigt. PWD für Installation ist:"  | tee -a  ~/Installation.log
                 echo $PWD  | tee -a  ~/Installation.log
                 echo $(date -u) "16.2 von 29: Erledigt. Neuer workspace für Installation ist:"  | tee -a  ~/Installation.log
                 echo $PS1  | tee -a  ~/Installation.log

echo $(date -u) "17 von 29: Protobuf 3.11.4 installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 sudo apt -y install autoconf automake libtool curl g++ 
                 rm -rf ~/protobuf
                 git clone https://github.com/protocolbuffers/protobuf.git
                 cd protobuf
                 git checkout v3.11.4
                 git submodule update --init --recursive

                 echo $(date -u) "17.1 von 29: Bugfix: coded_stream int auf long int"  | tee -a  ~/Installation.log
                 sed -i 's/uint8\* WriteRaw(const void\* data, int size, uint8\* ptr) {/uint8\* WriteRaw(const void\* data, size_t size, uint8\* ptr) {/g' ~/protobuf/src/google/protobuf/io/coded_stream.h
                 sed -i 's/if (PROTOBUF_PREDICT_FALSE(end_ - ptr < size)) {/if (PROTOBUF_PREDICT_FALSE(end_ - ptr < static_cast<long int>(size))) {/g' ~/protobuf/src/google/protobuf/io/coded_stream.h

                 cd ~/protobuf
                 ./autogen.sh
                 ./configure

                 cd ~/protobuf
                 make -j4 
                 sudo make install 
                 sudo ldconfig

echo $(date -u) "17.1 von 29: Protobuffer auf Version prüfen:"  | tee -a  ~/Installation.log
                 echo protoc --version   | tee -a  ~/Installation.log
                 protoc --version   | tee -a  ~/Installation.log

echo $(date -u) "18 von 29: Tensorflow+Keras, NumPy/SciPy installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install cython-doc
                 sudo apt -y install cython3
                 pip3 install -U numpy==1.18.4
                 pip3 install -U cython==0.29.17
                 pip3 install -U pycocotools==2.0.0
                 pip3 install -U scipy==1.4.1
                 pip3 install -U keras==2.3.1
                 pip3 install -U keras_preprocessing==1.1.0
                 pip3 install -U keras_applications==1.0.8
                 pip3 install -U future==0.18.2
                 pip3 install -U grpcio==1.28.1 absl-py==0.9.0 py-cpuinfo==5.0.0 psutil==5.7.0 portpicker==1.3.1 six==1.14.0 mock==4.0.2 requests==2.23.0 gast==0.2.2 
                 pip3 install -U h5py==2.10.0 astor==0.8.1 termcolor==1.1.0 wrapt==1.12.1 google-pasta==0.2.0 setuptools==46.1.3 testresources==2.0.1 
                 pip3 install -U pybind11==2.5.0
                 export CUDA_VISIBLE_DEVICES=0
                 export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib
                 export PATH=$PATH:/usr/local/cuda/bin
                 pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow-gpu==1.15.0+nv20.1
                 #sudo -H pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 ‘tensorflow<2’
                 echo 'export CUDA_VISIBLE_DEVICES=0' >> ~/.bashrc
                 echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib' >> ~/.bashrc
                 echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +3)"
                 set -e

echo $(date -u) "19 von 29: Installieren der Objekterkennung für TF"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 git clone https://github.com/tensorflow/models
                 cd models && git checkout -q b00783d
                 cd ~
                 git clone https://github.com/cocodataset/cocoapi.git
                 cd cocoapi/PythonAPI
                 python setup.py install
                 cd ~/models/research/
                 protoc object_detection/protos/*.proto --python_out=.
                 echo '#!/bin/sh' > ~/setup.sh
                 echo 'export PYTHONPATH=$PYTHONPATH:/home/'$Benutzer'/models/research:\' >> ~/setup.sh
                 echo '/home/'$Benutzer'/models/research/slim' >> ~/setup.sh

                 echo 'export PYTHONPATH=$PYTHONPATH:/home/'$Benutzer'/models/research:\' >> ~/bashrc
                 echo '/home/'$Benutzer'/models/research/slim' >> ~/bashrc.sh
                 echo $(date -u) "19.1 von 29: PYTHONPATH kontrollieren:"  | tee -a  ~/Installation.log
                 export PYTHONPATH=$PYTHONPATH:/home/$Benutzer/models/research:/home/$Benutzer/models/research/slim:/home/$Benutzer/.local/lib/python3.6/site-packages/
                 echo $PYTHONPATH  | tee -a  ~/Installation.log

echo $(date -u) "20 von 29: Installation von NVIDIA vor-trainierten Modelle für TensorFlow / TensorRT"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 git clone https://github.com/jkjung-avt/tf_trt_models.git
                 cd tf_trt_models
                 ./install.sh

echo $(date -u) "21 von 29: OpenJPG, OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install jasper 
                 #libatlas3-base libatlas-base-dev liblapacke-dev
                 cd ~
                 wget https://github.com/uclouvain/openjpeg/archive/v2.3.1.zip
                 unzip v2.3.1.zip
                 cd openjpeg-2.3.1/
                 mkdir build
                 cd build
                 cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_PROTOBUF=ON
                 make -j4
                 cd ~/openjpeg-2.3.1/build
                 sudo make install
                 sudo make clean
                 #cd ~/openjpeg-2.3.1/build
                 #make doc

                 cd ~
                 wget -O opencv.zip https://github.com/opencv/opencv/archive/4.3.0.zip
                 wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.3.0.zip
                 unzip opencv.zip
                 unzip opencv_contrib.zip
                 mv opencv-4.3.0 opencv
                 mv opencv_contrib-4.3.0 opencv_contrib
                 cd opencv
                 rm -rf build
                 mkdir build
                 cd build

echo $(date -u) "22 von 29: OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cmake	-D CMAKE_BUILD_TYPE=RELEASE \
                        -D OPENCV_GENERATE_PKGCONFIG=YES \
                        -D WITH_CUDA=ON \
                        -D CUDA_ARCH_PTX="" \
                        -D CUDA_ARCH_BIN="5.3,6.2,7.2" \
                        -D WITH_CUBLAS=ON \
                        -D WITH_LIBV4L=ON \
                        -D BUILD_opencv_python3=ON \
                        -D BUILD_opencv_python2=OFF \
                        -D BUILD_opencv_java=OFF \
                        -D WITH_GSTREAMER=ON \
                        -D WITH_GTK=ON \
                        -D BUILD_TESTS=OFF \
                        -D BUILD_PERF_TESTS=OFF \
                        -D BUILD_EXAMPLES=OFF \
                        -D OPENCV_ENABLE_NONFREE=ON \
                        -D OPENCV_EXTRA_MODULES_PATH=/home/$Benutzer/opencv_contrib/modules ..
                 make  -j4
                 sudo make install

echo $(date -u) "23 von 29: OpenCV Symbolic-Link setzen "  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~/.virtualenvs/tf15cv4/lib/python3.6/site-packages/
                 ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so

echo $(date -u) "24 von 29: Weitere Bibliotheken installieren (nice2have)"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~

                 pip3 install -U matplotlib==3.2.1 scikit-learn
                 sudo apt -y install python3-tk
                 #pip install -U --no-cache-dir scikit-build blosc imagecodecs
                 pip3 install pillow==7.1.2 imutils==0.5.3 
                 #scikit-image

echo $(date -u) "25 von 29: Installation von dlib und face recognition"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 wget http://dlib.net/files/dlib-19.19.tar.bz2
                 tar xvf dlib-19.19.tar.bz2
                 cd dlib-19.19/
                 mkdir build
                 cd build
                 cmake ..
                 cmake --build . --config Release
                 sudo make install
                 sudo ldconfig

echo $(date -u) "26 von 29: Kleiner WEBServer, Jupyter Notebook und Systemtoolsmachen die Arbeit einfacher"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 pip3 install flask jupyter
                 sudo -H pip3 install -U jetson-stats
                 cd ~

echo $(date -u) "27 von 29: XML-Tool und Fortschrittsanzeige"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 pip3 install -U lxml progressbar2

echo $(date -u) "28 von 29: SwapFile auf 2.0GB pro Kern setzen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 git clone https://github.com/JetsonHacksNano/resizeSwapMemory
                 cd resizeSwapMemory
                 ./setSwapMemorySize.sh -g 8
                 sudo apt -y clean
                 

echo $(date -u) "29 von 29: Aufräumen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cat ~/path_input >> ~/.bashrc
                 #export PATH=$(echo $PATH | awk -F: '{ for (i = 1; i <= NF; i++) arr[$i]; } END { for (i in arr) printf "%s:" , i; printf "\n"; } ') >> ~/.bashrc

                 #PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}') >> ~/.bashrc
                 #PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}')
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +1)"
                 set -e
                 #sudo apt -y clean
                 #echo "export PATH=$(echo $PATH | awk -F: '{ for (i = 1; i <= NF; i++) arr[$i]; } END { for (i in arr) printf "%s:" , i; printf "\n"; } ') " >> ~/.bashrc
                 #export PATH=$(echo $PATH | awk -F: '{ for (i = 1; i <= NF; i++) arr[$i]; } END { for (i in arr) printf "%s:" , i; printf "\n"; } ')

                 #git clone https://github.com/AlexeyAB/darknet.git
                 #cd ~/darknet
                 #wget http://images.cocodataset.org/zips/test2017.zip
                 
                 
echo $(date -u) "Ende der Installation. "   | tee -a  ~/Installation.log
echo $(date -u) "Bitte als root den Script nvidiaNOsudoers.sh ausführen!"   | tee -a  ~/Installation.log
echo $(date -u) "Bitte als root den Script Finalisieren.sh ausführen!"      | tee -a  ~/Installation.log
echo $(date -u) "======================================================="   | tee -a  ~/Installation.log
                 #sudo reboot


