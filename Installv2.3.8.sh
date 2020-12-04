#!/usr/bin/env bash


# Es wird empfohlen nvidia als Benutzer zu verwenden da leider einige Softwarepakete diesen hardcodiert enthalten (können) und man sucht dann lange nach Fehlern
Benutzer="nvidia"


# Hier kann die Tensorflow - Version gesetzt werden, welche installiert werden soll.
# 1 bedeutet: Letzte aktuelle Version 1.x.x. wird installiert.
# 2 bedeutet: Letzte aktuelle Version 2.x.x. wird installiert.
TensorFlow="1"

if [ "$(whoami)" != $Benutzer ]; then
        echo $(date -u) "Script muss als Benutzer $Benutzer ausgeführt werden!"
        exit 255
fi

#Debug Modus: -x = an, +x = aus
set +x

# Name der virtuellen Umgebung, kann nach persönlichem Geschmack problemlos geändert werden
VirtEnv="tf15cv4"

#Vorbelegung CompilerFlags und Warnungen zu unterdrücken die durch automatisch generierten Code schnell mal entstehen können und keine wirkliche Relevanz haben
export CFLAGS=$CFLAGS" -w"
export CPPFLAGS=$CPPFLAGS" -w"
export CXXFLAGS=$CXXFLAGS" -w"

#Vermeiden von ReadTimeOut bei PIP, falls mal die Verbindung Probleme macht
export PIP_DEFAULT_TIMEOUT=100

rm -rf ~/nvjetson_opencv_gsi

# Highspeed - Modus setzen
grep -q Jetson-AGX /proc/device-tree/model && sudo nvpmodel -m 3
grep -q Xavier /proc/device-tree/model && sudo nvpmodel -m 2
grep -q Nano /proc/device-tree/model   && sudo nvpmodel -m 0
sudo jetson_clocks

# Stopp bei Fehler an (-e)
# Wird vor der Ausführung von eval bashrc ausgeschaltet da Shell-In-Shell return's einen Fehler erzeugen (können) der bei der Installation aber nicht relevant ist
set -e

echo $(date -u) "Test auf bestehende Installation.log"
                 test -f ~/Installation.log && rm ~/Installation.log

echo $(date -u) "Installation.log anlegen"
                 touch ~/Installation.log

echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "# Objekterkennung mit OpenCV, TensorFlow, YOLO. By WIEGEHTKI.DE                                                                     #" | tee -a  ~/Installation.log
echo $(date -u) "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anzuwenden                                                            #" | tee -a  ~/Installation.log
echo $(date -u) "#                                                                                                                                   #" | tee -a  ~/Installation.log
echo $(date -u) "# V2.3.8 (Rev f), 03.12.2020 - Unterstützt NVIDIA Jetson NANO und NVIDIA Jetson Xavier NX, Beta für AGX mit JP 4.4.1                #" | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################" | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "01 von 30: SUDO - Rechte um ohne Passworteingabe zukünftig installieren zu können als root durchgeführt?"  | tee -a  ~/Installation.log
echo $(date -u) "Hier die Befehle dazu:" | tee -a  ~/Installation.log
echo $(date -u) "   chmod +x *sh"        | tee -a  ~/Installation.log
echo $(date -u) "   sudo su"             | tee -a  ~/Installation.log
echo $(date -u) "   ./nvidia2sudoers.sh" | tee -a  ~/Installation.log
echo $(date -u) "   exit"                | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "02 von 30: Aktuelle Installationsparameter:" | tee -a  ~/Installation.log
echo $(date -u) "Benutzer: '$Benutzer'" | tee -a  ~/Installation.log
echo $(date -u) "Virtual Environment Wrapper: '$VirtEnv'" | tee -a  ~/Installation.log
echo $(date -u) "Compilerflags: CFLAGS:'$CFLAGS' CPPFLAGS:'$CPPFLAGS' CXXFLAGS:'$CXXFLAGS'" | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
echo $(date -u) "03 von 30: Systemupdate"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y update
                 sudo apt -y dist-upgrade
                 sudo ldconfig
                 sudo apt update --fix-missing

echo $(date -u) "04 von 30: Swap-File mit 8GB anlegen, aktivieren und kontrollieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install nano
                 sudo fallocate -l 8G /swapfile
                 sudo chmod 600 /swapfile
                 sudo mkswap /swapfile
                 sudo swapon /swapfile
                 sudo swapon --show

echo $(date -u) "05 von 30: Systemwerkzeuge, Editor, Tools, Erweiterungen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install git-all doxygen build-essential nghttp2 libnghttp2-dev libssl-dev apt-utils
                 sudo apt -y install libatlas-base-dev liblapack-dev libblas-dev gfortran
                 sudo apt -y install libhdf5-serial-dev hdf5-tools


echo $(date -u) "06 von 30: Pakete zur Vorbereitung für SciPy"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libfreetype6-dev python3-setuptools
                 sudo apt -y install protobuf-compiler libprotobuf-dev openssl
                 sudo apt -y install libcurl4-openssl-dev

echo $(date -u) "07 von 30: XML Tool für Tensorflow API Objekterkennung"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libxml2-dev libxslt1-dev

echo $(date -u) "08 von 30: Pakete für OpenCV incl. Codecs, Image und GUI Bibliotheken"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install pkg-config qt4-dev-tools qt4-qmake
                 sudo apt -y install libtbb2 libtbb-dev libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
                 sudo apt -y install libtiff-dev libjpeg-dev libpng-dev
                 sudo apt -y install python-tk libgtk-3-dev libcanberra-gtk-module libcanberra-gtk3-module

echo $(date -u) "09 von 30: Pakete für die (USB) Kamera"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install libdc1394-22-dev libv4l-dev v4l-utils qv4l2 v4l2ucp

echo $(date -u) "10 von 30: WIEGEHTKI Repo-clone"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git
		 chmod +x ~/nvjetson_opencv_gsi/*
                 mv ~/nvjetson_opencv_gsi/darknet.repo ~/darknet
		 mv ~/nvjetson_opencv_gsi/smartcam.sh  ~/darknet/
		 cp -r ~/nvjetson_opencv_gsi/Objekterkennung/Videos_Ausgabe ~/darknet/
		 cp -r ~/nvjetson_opencv_gsi/Objekterkennung/Videos_Eingabe ~/darknet/
		 chmod +x ~/darknet/*

echo $(date -u) "11 von 30: PreCompiler: cmake 3.19.0"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y purge cmake
                 wget https://www.cmake.org/files/v3.19/cmake-3.19.1.tar.gz
                 tar xpvf cmake-3.19.1.tar.gz
                 cd   ~/cmake-3.19.1/
                 ./bootstrap
                 make   -j4

                 echo 'export PATH=/home/'$Benutzer'/cmake-3.19.1/bin/:/home/'$Benutzer'/.local/bin/:$PATH' >> ~/.bashrc
                 export PATH=/home/$Benutzer/cmake-3.19.1/bin/:/home/$Benutzer/.local/bin/:$PATH
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +1)"
                 set -e

echo $(date -u) "12 von 30: Pfadprüfung - Pfad ist gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 echo $PATH  | tee -a  ~/Installation.log

echo $(date -u) "13 von 30: Pythonpakete und Tools"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 wget https://bootstrap.pypa.io/get-pip.py
                 sudo python3 get-pip.py
                 rm get-pip.py
                 sudo apt -y install python3-pip
                 sudo pip3 install -U pip testresources setuptools

echo $(date -u) "14 von 30: Virtuelle Umgebung installieren, anpassen und aktivieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 sudo pip3 install virtualenv virtualenvwrapper
                 export WORKON_HOME=$HOME/.virtualenvs
                 export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

                 echo '#virtualenv and virtualenvwrapper' >> ~/.bashrc
                 echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
                 echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
                 echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc

                 set +e
                 eval "$(cat ~/.bashrc | tail -n +3)"
                 set -e

echo $(date -u) "15 von 30: Environmentprüfung - gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 echo $WORKON_HOME  | tee -a  ~/Installation.log
                 echo $VIRTUALENVWRAPPER_PYTHON  | tee -a  ~/Installation.log

echo $(date -u) "16 von 30: Virtuelle Umgebung bauen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 set +e
                 mkvirtualenv $VirtEnv -p python3
                 workon $VirtEnv
                 set -e
                 cd ~
                 ~/.virtualenvs/$VirtEnv/bin/python -m pip install --upgrade pip

                 echo $(date -u) "16.1 von 30: Erledigt. PWD für Installation ist:"  | tee -a  ~/Installation.log
                 echo $PWD  | tee -a  ~/Installation.log
                 echo $(date -u) "16.2 von 30: Erledigt. Neuer workspace für Installation ist:"  | tee -a  ~/Installation.log
                 echo $PS1  | tee -a  ~/Installation.log

echo $(date -u) "17 von 30: Protobuffer auf Version prüfen:"  | tee -a  ~/Installation.log
                 echo protoc --version   | tee -a  ~/Installation.log
                 protoc --version   | tee -a  ~/Installation.log

echo $(date -u) "18 von 30: Tensorflow+Keras, NumPy/SciPy installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt-get update
                 sudo apt-get install libhdf5-serial-dev hdf5-tools libhdf5-dev zlib1g-dev zip libjpeg8-dev liblapack-dev libblas-dev gfortran
                 sudo apt-get install python3-pip
                 sudo pip3 install -U pip testresources setuptools==49.6.0               
                 sudo pip3 install -U numpy==1.16.1 future==0.18.2 mock==3.0.5 h5py==2.10.0 keras_preprocessing==1.1.1 keras_applications==1.0.8 gast==0.3.3 futures protobuf pybind11
                 sudo apt -y install cython3
                 sudo apt -y install python3-matplotlib
                 sudo pip3 install -U --ignore-installed pycocotools==2.0.2
                 sudo pip3 install -U scipy==1.4.1
                 sudo pip3 install -U keras==2.3.1
                 sudo pip3 install -U grpcio absl-py==0.9.0 py-cpuinfo==5.0.0 psutil==5.7.0 portpicker==1.3.1 six==1.14.0 requests==2.23.0 
                 sudo pip3 install -U astor==0.8.1 termcolor==1.1.0 wrapt==1.12.1 google-pasta==0.2.0  

                 export CUDA_VISIBLE_DEVICES=0
                 export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib
                 export PATH=$PATH:/usr/local/cuda/bin
                 
                 if [ $TensorFlow = "1" ]
                 then
                          sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 'tensorflow<2'
                 else
                          sudo pip3 install --pre --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v44 tensorflow
                 fi
                
                 echo 'export CUDA_VISIBLE_DEVICES=0' >> ~/.bashrc
                 echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib' >> ~/.bashrc
                 echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +3)"
                 set -e

echo $(date -u) "19 von 30: Installieren der Objekterkennung für TF"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 echo "Installation de-aktiviert da es hier nicht benötigt wird."  | tee -a  ~/Installation.log
                 #cd ~
                 #git clone https://github.com/tensorflow/models
                 #cd models && git checkout -q b00783d
                 #cd ~
                 #git clone https://github.com/cocodataset/cocoapi.git
                 #cd cocoapi/PythonAPI
                 #sudo python3 setup.py install
                 #cd ~/models/research/
                 #protoc object_detection/protos/*.proto --python_out=.
                 #echo '#!/bin/sh' > ~/setup.sh
                 #echo 'export PYTHONPATH=$PYTHONPATH:/home/'$Benutzer'/models/research:\' >> ~/setup.sh
                 #echo '/home/'$Benutzer'/models/research/slim' >> ~/setup.sh

                 #echo 'export PYTHONPATH=$PYTHONPATH:/home/'$Benutzer'/models/research:\' >> ~/bashrc
                 #echo '/home/'$Benutzer'/models/research/slim' >> ~/bashrc.sh
                 #echo $(date -u) "19.1 von 30: PYTHONPATH kontrollieren:"  | tee -a  ~/Installation.log
                 #export PYTHONPATH=$PYTHONPATH:/home/$Benutzer/models/research:/home/$Benutzer/models/research/slim:/home/$Benutzer/.local/lib/python3.6/site-packages/
                 #echo $PYTHONPATH  | tee -a  ~/Installation.log

echo $(date -u) "20 von 30: Installation von NVIDIA vor-trainierten Modelle für TensorFlow / TensorRT"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~
                 git clone https://github.com/jkjung-avt/tf_trt_models.git
                 cd tf_trt_models
                 ./install.sh

echo $(date -u) "21 von 30: OpenJPG, OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 sudo apt -y install jasper
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

echo $(date -u) "22 von 30: OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
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

echo $(date -u) "23 von 30: OpenCV Symbolic-Link setzen "  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~/.virtualenvs/tf15cv4/lib/python3.6/site-packages/
                 ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so

echo $(date -u) "24 von 30: Weitere Bibliotheken installieren (nice2have)"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cd ~

                 pip3 install -U matplotlib==3.2.1 scikit-learn
                 sudo apt -y install python3-tk
                 pip3 install pillow==7.1.2 imutils==0.5.3 

echo $(date -u) "25 von 30: Installation von dlib und face recognition"  | tee -a  ~/Installation.log
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

echo $(date -u) "26 von 30: Kleiner WEBServer, Jupyter Notebook und Systemtoolsmachen die Arbeit einfacher"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 pip3 install flask jupyter
                 sudo pip3 install -U jetson-stats
                 cd ~

echo $(date -u) "27 von 30: XML-Tool und Fortschrittsanzeige"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 pip3 install -U lxml progressbar2

echo $(date -u) "28 von 30: SwapFile auf 2.0GB pro Kern setzen"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 git clone https://github.com/JetsonHacksNano/resizeSwapMemory
                 cd resizeSwapMemory
                 ./setSwapMemorySize.sh -g 8
                 sudo apt -y clean

echo $(date -u) "29 von 30: Download Yolov3 und v4 - Weights"  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
		 cd ~
                (ls ~/darknet/YoloWeights >> /dev/null 2>&1 && echo Verzeichnis existiert bereits) || echo Lege YoloWeights - Verzeichnis an && mkdir ~/darknet/YoloWeights
                (ls ~/darknet/YoloWeights/yolov4.weights >> /dev/null 2>&1 && echo yolov4.weights bereits vorhanden) || echo Bitte Geduld, lade yolov4.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT" -O ~/darknet/YoloWeights/yolov4.weights && rm -rf /tmp/cookies.txt
                (ls ~/darknet/YoloWeights/yolov3.weights >> /dev/null 2>&1 && echo yolov3.weights bereits vorhanden) || echo Bitte Geduld, lade yolov3.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A" -O ~/darknet/YoloWeights/yolov3.weights && rm -rf /tmp/cookies.txt
                (ls ~/darknet/YoloWeights/yolov3-tiny.weights >> /dev/null 2>&1 && echo yolov3-tiny.weights bereits vorhanden) || echo Bitte Geduld, lade yolov3-tiny.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt" -O ~/darknet/YoloWeights/yolov3-tiny.weights && rm -rf /tmp/cookies.txt

echo $(date -u) "30 von 30: Pfad eintragen und reboot."  | tee -a  ~/Installation.log
echo $(date -u) "....................................................................................................................................." | tee -a  ~/Installation.log
                 cat ~/nvjetson_opencv_gsi/path.input >> ~/.bashrc
                 set +e
                 eval "$(cat ~/.bashrc | tail -n +1)"
                 set -e

echo $(date -u) "Ende der Installation. "   | tee -a  ~/Installation.log
echo $(date -u) "Bitte als root den Script nvidiaNOsudoers.sh ausführen!"   | tee -a  ~/Installation.log
echo $(date -u) "Bitte als root den Script Finalisieren.sh ausführen!"      | tee -a  ~/Installation.log
echo $(date -u) "Bei Problemen mit YOLO: Terminal aufrufen, in darknet wechseln und make aufrufen."   | tee -a  ~/Installation.log
echo $(date -u) "================================================================================="   | tee -a  ~/Installation.log
                 # Stopp bei Fehler aus (+e)
                 set +e

                 # Performance zurück auf Standard
                 grep -q Jetson-AGX /proc/device-tree/model && sudo nvpmodel -m 1
                 grep -q Xavier /proc/device-tree/model     && sudo nvpmodel -m 3
                 grep -q Nano /proc/device-tree/model       && sudo nvpmodel -m 1
                 sudo nvpmodel -q
                 sudo reboot



