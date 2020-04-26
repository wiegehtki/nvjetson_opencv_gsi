#!/usr/bin/env bash

if [ "$(whoami)" != "nvidia" ]; then
        echo $(date -u) "Script muss als Benutzer nvidia ausgeführt werden!"
        exit 255
fi

set -x

rm ~/Installation.log
touch ~/Installation.log

echo "########################################################################"  | tee -a  ~/Installation.log
echo "# Objekterkunng mit OpenCV, TensoFlow, Yolov3. By WIEGEHTKI.DE         #"  | tee -a  ~/Installation.log
echo "# Zur freien Verwendung. Ohne Gewähr und nur auf Testsystemen anwenden #"  | tee -a  ~/Installation.log
echo "# V2.3, 24.04.2020                                                     #"  | tee -a  ~/Installation.log
echo "########################################################################"  | tee -a  ~/Installation.log
echo " "  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "01 von 29: SUDO - rechte um ohne Passworteingabe zukünftig installieren zu können als root durchgeführt?"  | tee -a  ~/Installation.log
echo $(date -u) "Hier die Befehle dazu:"  | tee -a  ~/Installation.log
echo $(date -u) "sudo su"  | tee -a  ~/Installation.log
echo $(date -u) "chmod +x *.sh"  | tee -a  ~/Installation.log
echo $(date -u) "./Installv2.3.sh"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"

#sudo cp /etc/sudoers /etc/sudoers.bak
#sudo echo 'nvidia ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "02 von 29: Systemupdate"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y update
sudo apt -y upgrade
sudo ldconfig
sudo apt -y autoremove
#sudo reboot

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "03 von 29: Upgrade inkl. Firmware update (falls erforderlich)"   | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y dist-upgrade

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "04 von 29: Swap-File mit 8GB anlegen, aktivieren und kontrollieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install nano
sudo fallocate -l 8G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
#sudo echo $(date -u) "/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo swapon --show

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "05 von 29: Systemwerkzeuge, Editor, Tools"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install git-all
sudo apt -y install libatlas-base-dev gfortran
sudo apt -y install libhdf5-serial-dev hdf5-tools
sudo apt -y install python3-dev locate

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "06 von 29: Pakete für SciPy"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install libfreetype6-dev python3-setuptools
sudo apt -y install protobuf-compiler libprotobuf-dev openssl
sudo apt -y install libssl-dev libcurl4-openssl-dev
sudo apt -y install cython3

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "07 von 29: XML Tool für Tensorflow API Objekterkennung"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install libxml2-dev libxslt1-dev

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "08 von 29: Pakete für OpenCV incl. Codecs, Image und GUI Bibliotheken"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install build-essential pkg-config
sudo apt -y install libtbb2 libtbb-dev libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libavresample-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
sudo apt -y install libtiff-dev libjpeg-dev libpng-dev
sudo apt -y install python-tk libgtk-3-dev libcanberra-gtk-module libcanberra-gtk3-module

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "09 von 29: Pakete für die (USB) Kamera"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install libdc1394-22-dev libv4l-dev v4l-utils qv4l2 v4l2ucp

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "10 von 29: WIEGEHTKI Repo-clone"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~
git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "11 von 29: PreCompiler: cmake 3.17.1"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y purge cmake
wget http://www.cmake.org/files/v3.17/cmake-3.17.1.tar.gz
tar xpvf cmake-3.17.1.tar.gz
cd   ~/cmake-3.17.1/
./bootstrap
make   -j4

echo 'export PATH=/home/nvidia/cmake-3.17.1/bin/:/home/nvidia/.local/bin/:$PATH' >> ~/.bashrc
export PATH=/home/nvidia/cmake-3.17.1/bin/:/home/nvidia/.local/bin/:$PATH
eval "$(cat ~/.bashrc | tail -n +1)"
sudo apt -y autoremove

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "12 von 29: Pfadprüfung - Pfad ist gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
echo $PATH  | tee -a  ~/Installation.log

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "13 von 29: Pythonpakete und Tools"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
wget https://bootstrap.pypa.io/get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "14 von 29: Virtuelle Umgebung installieren, anpassen und aktivieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~
sudo -H pip3 install virtualenv virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3


echo '#virtualenv and virtualenvwrapper' >> ~/.bashrc
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "15 von 29: Environmentprüfung - gesetzt auf:"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
echo $WORKON_HOME  | tee -a  ~/Installation.log
echo $VIRTUALENVWRAPPER_PYTHON  | tee -a  ~/Installation.log

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "16 von 29: Virtuelle Umgebung bauen"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
eval "$(cat ~/.bashrc | tail -n +3)"
#chmod a+x ~/.bashrc
#PS1='$ '
#source ~/.bashrc
mkvirtualenv py3cv4  -p python3
workon py3cv4

echo $(date -u) "16.1 von 29: Erledigt. PWD für Installation ist:"  | tee -a  ~/Installation.log
echo $PWD  | tee -a  ~/Installation.log
echo $(date -u) "16.2 von 29: Erledigt. Neuer workspace für Installation ist:"  | tee -a  ~/Installation.log
echo $PS1  | tee -a  ~/Installation.log

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "17 von 29: Protobuf 3.11.4 installieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~
apt -y install autoconf automake libtool curl g++ 
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git submodule update --init --recursive
./autogen.sh
./configure
make -j4
make check
sudo make install
sudo ldconfig

#wget https://raw.githubusercontent.com/jkjung-avt/jetson_nano/master/install_protobuf-3.11.4.sh
#cp -r ~/nvjetson_opencv_gsi/install_protobuf-3.11.4.sh ~/.
#cd ~
#sudo chmod +x install_protobuf-3.11.4.sh
#./install_protobuf-3.11.4.sh
#cd ~
#cp -r ~/src/protobuf-3.11.4/python/ .
#cd python
#python setup.py install --cpp_implementation

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "18 von 29: Tensorflow+Keras, NumPy/SciPy installieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y install cython-doc
pip3 install numpy
pip3 install cython 
pip3 install pycocotools
pip3 install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow-gpu==1.15.0+nv20.1
pip3 install scipy
pip3 install keras
pip3 install pybind11
export CUDA_VISIBLE_DEVICES=1
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib
export PATH=$PATH:/usr/local/cuda/bin
echo 'export CUDA_VISIBLE_DEVICES=1' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64:/usr/local/lib' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
eval "$(cat ~/.bashrc | tail -n +3)"

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "19 von 29: Installieren der Objekterkennung für TF"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
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
echo 'export PYTHONPATH=$PYTHONPATH:/home/nvidia/models/research:\' >> ~/setup.sh
echo '/home/nvidia/models/research/slim' >> ~/setup.sh

echo 'export PYTHONPATH=$PYTHONPATH:/home/nvidia/models/research:\' >> ~/bashrc
echo '/home/nvidia/models/research/slim' >> ~/bashrc.sh
eval "$(cat ~/.bashrc | tail -n +3)"

echo $(date -u) "19.1 von 29: PYTHONPATH kontrollieren:"  | tee -a  ~/Installation.log
export PYTHONPATH=$PYTHONPATH:/home/nvidia/models/research:/home/nvidia/models/research/slim:/home/nvidia/.local/lib/python3.6/site-packages/
echo $PYTHONPATH  | tee -a  ~/Installation.log

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "20 von 29: Installation von NVIDIA vor-trainierten Modelle für TensorFlow / TensorRT"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~
# Fehler da nur Python2 support: git clone --recursive https://github.com/NVIDIA-Jetson/tf_trt_models.git
git clone https://github.com/jkjung-avt/tf_trt_models.git
cd tf_trt_models
./install.sh

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "21 von 29: OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
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

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "22 von 29: OpenCV herunterladen, compilieren und installieren"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
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
-D OPENCV_EXTRA_MODULES_PATH=/home/nvidia/opencv_contrib/modules ..
make  -j4
sudo make install

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "23 von 29: OpenCV Symbolic-Link setzen "  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~/.virtualenvs/py3cv4/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "24 von 29: Weitere Bibliotheken installieren (nice2have)"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
cd ~
pip3 install matplotlib python3-tk scikit-learn
pip3 install pillow imutils scikit-image

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "25 von 29: Installation von dlib und facerecognition"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
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

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "26 von 29: Kleiner WEBServer, Jupyter Notebook und Systemtoolsmachen die Arbeit einfacher"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
pip3 install flask jupyter
sudo -H pip3 install -U jetson-stats

#echo $(date -u) "23 von 29: Beispiele von WIEGHTKI ziehen"  | tee -a  ~/Installation.log
cd ~
#git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "27 von 29: XML-Tool und Fortschrittsanzeige"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
pip3 install lxml progressbar2

#echo $(date -u) "SUDO - Rechte zurücksetzen um ohne Passworteingabe installieren zu können"
#sudo cp /etc/sudoers.bak /etc/sudoers

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "28 von 29: Aufräumen"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
sudo apt -y autoremove
sudo apt -y clean
PATH=$(echo -n $PATH | awk -v RS=: '!($0 in a) {a[$0]; printf("%s%s", length(a) > 1 ? ":" : "", $0)}') >> ~/.bashrc

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "29 von 29: SwapFile auf 2.0GB pro Kern setzen"  | tee -a  ~/Installation.log
echo $(date -u) "#####################################################################################################################################"
git clone https://github.com/JetsonHacksNano/resizeSwapMemory
cd resizeSwapMemory
./setSwapMemorySize.sh -g 8

echo $(date -u) "#####################################################################################################################################"
echo $(date -u) "Ende der Installation. Bitte als root den Script nvidiaNOsudoers.sh ausführen!"   | tee -a  ~/Installation.log
echo $(date -u) "=============================================================================="
#sudo reboot


