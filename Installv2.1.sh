#!/usr/bin/env bash

if [ "$(whoami)" != "nvidia" ]; then
        echo "Script muss als Benutzer nvidia ausgeführt werden!"
        exit 255
fi

set -x

touch ~/Installation.log
echo "1 von 26: : SUDO - rechte um ohne Passworteingabe zukünftig installieren zu können" >> ~/Installation.log
#sudo cp /etc/sudoers /etc/sudoers.bak
#sudo echo 'nvidia ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

echo "2 von 26: Systemupdate" >> ~/Installation.log
sudo apt -y update
sudo apt -y upgrade
sudo ldconfig
sudo apt -y autoremove
#sudo reboot

echo "3 von 26: Upgrade inkl. Firmware update (falls erforderlich)"  >> ~/Installation.log
sudo apt -y dist-upgrade

echo "4 von 26: Swap-File anlegen  4GB, aktivieren und kontrollieren" >> ~/Installation.log
sudo apt -y install nano
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
sudo swapon --show

echo "5 von 26: Systemwerkzeuge, Editor, Tools" >> ~/Installation.log
sudo apt -y install git-all
sudo apt -y install libatlas-base-dev gfortran
sudo apt -y install libhdf5-serial-dev hdf5-tools
sudo apt -y install python3-dev locate

echo "6 von 26: Pakete für SciPy" >> ~/Installation.log
sudo apt -y install libfreetype6-dev python3-setuptools
sudo apt -y install protobuf-compiler libprotobuf-dev openssl
sudo apt -y install libssl-dev libcurl4-openssl-dev
sudo apt -y install cython3

echo "7 von 26: XML Tool für Tensorflow API Objekterkennung" >> ~/Installation.log
sudo apt -y install libxml2-dev libxslt1-dev

echo "8 von 26: Pakete für OpenCV incl. Codecs, Image und GUI Bibliotheken" >> ~/Installation.log
sudo apt -y install build-essential pkg-config
sudo apt -y install libtbb2 libtbb-dev libavcodec-dev libavformat-dev libswscale-dev libxvidcore-dev libavresample-dev
sudo apt -y install libtiff-dev libjpeg-dev libpng-dev
sudo apt -y install python-tk libgtk-3-dev libcanberra-gtk-module libcanberra-gtk3-module

echo "9 von 26: Pakete für die (USB) Kamera" >> ~/Installation.log
sudo apt -y install libv4l-dev libdc1394-22-dev v4l-utils

echo "10 von 26: PreCompiler: cmake" >> ~/Installation.log
sudo apt -y purge cmake
wget http://www.cmake.org/files/v3.17/cmake-3.17.0.tar.gz
tar xpvf cmake-3.17.0.tar.gz
cd   ~/cmake-3.17.0/
./bootstrap
make   -j4
echo 'export PATH=/home/nvidia/cmake-3.17.0/bin/:/home/nvidia/.local/bin/:$PATH' >> ~/.bashrc
eval "$(cat ~/.bashrc | tail -n +1)"
sudo apt -y autoremove
echo "11.1 von 26: Pfadprüfung - Pfad ist gesetzt auf:" >> ~/Installation.log
echo $PATH >> ~/Installation.log

echo "11 von 26: Pythonpakete und Tools" >> ~/Installation.log
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
rm get-pip.py

echo "12 von 26: Virtuelle Umgebung installieren, anpassen und aktivieren" >> ~/Installation.log
sudo pip install virtualenv virtualenvwrapper
echo '#virtualenv and virtualenvwrapper' >> ~/.bashrc
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc
echo "12.1 von 26: Environmentprüfung - gesetzt auf:" >> ~/Installation.log
echo $WORKON_HOME >> ~/Installation.log
echo $VIRTUALENVWRAPPER_PYTHON >> ~/Installation.log

echo "13 von 26: Virtuelle Umgebung bauen" >> ~/Installation.log
eval "$(cat ~/.bashrc | tail -n +3)"
#chmod a+x ~/.bashrc
#PS1='$ '
#source ~/.bashrc
mkvirtualenv py3cv4  -p python3
workon py3cv4

echo "13.1 von 26: Erledigt. Neuer workspace für Installation ist:" >> ~/Installation.log
pwd >> Installation.log

echo "14 von 26: Protobuf installieren" >> ~/Installation.log
wget https://raw.githubusercontent.com/jkjung-avt/jetson_nano/master/install_protobuf-3.6.1.sh
sudo chmod +x install_protobuf-3.6.1.sh
./install_protobuf-3.6.1.sh
cd ~
cp -r ~/src/protobuf-3.6.1/python/ .
cd python
python setup.py install --cpp_implementation

echo "15 von 26: Tensorflow+Keras, NumPy/SciPy installieren" >> ~/Installation.log
pip install numpy
pip install cython
pip install --extra-index-url https://developer.download.nvidia.com/compute/redist/jp/v43 tensorflow-gpu==1.15.0+nv20.1
pip install scipy
pip install keras
pip3 install pybind11
echo 'export CUDA_VISIBLE_DEVICES=1' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=/usr/local/cuda/lib64' >> ~/.bashrc
echo 'export PATH=$PATH:/usr/local/cuda/bin' >> ~/.bashrc
eval "$(cat ~/.bashrc | tail -n +3)"

echo "16 von 26: Installieren der Objekterkennung für TF" >> ~/Installation.log
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

echo "17 von 26: Installation von NVIDIA vor-trainierten Modelle für TensorFlow / TensorRT" >> ~/Installation.log
cd ~
git clone --recursive https://github.com/NVIDIA-Jetson/tf_trt_models.git
cd tf_trt_models
./install.sh

echo "18 von 26: OpenCV herunterladen, compilieren und installieren" >> ~/Installation.log
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

echo "19 von 26: OpenCV herunterladen, compilieren und installieren" >> ~/Installation.log
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

echo "19 von 26: OpenCV Symbolic-Link setzen " >> ~/Installation.log
cd ~/.virtualenvs/py3cv4/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/site-packages/cv2/python-3.6/cv2.cpython-36m-aarch64-linux-gnu.so cv2.so

echo "20 von 26: Weitere Bibliotheken installieren (nice2have)" >> ~/Installation.log
cd ~
pip install matplotlib scikit-learn
pip install pillow imutils scikit-image

echo "21 von 26: Installation von dlib und facerecognition" >> ~/Installation.log
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

echo "22 von 26: Kleiner WEBServer und Jupyter Notebook machen die Arbeit einfacher" >> ~/Installation.log
pip install flask jupyter

echo "23 von 26: Beispiele von WIEGHTKI ziehen" >> ~/Installation.log
cd ~
git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git

echo "24 von 26: XML-Tool und Fortschrittsanzeige" >> ~/Installation.log
pip install lxml progressbar2

#echo "SUDO - Rechte zurücksetzen um ohne Passworteingabe installieren zu können"
#sudo cp /etc/sudoers.bak /etc/sudoers

echo "25 von 26: Aufräumen" >> ~/Installation.log
sudo apt -y autoremove
sudo apt -y clean

echo "26 von 26: SwapFile auf 2.0GB pro Kern setzen" >> ~/Installation.log
git clone https://github.com/JetsonHacksNano/resizeSwapMemory
cd resizeSwapMemory
./setSwapMemorySize.sh -g 8

echo "Ende der Installation. Bitte als root den Script nvidiaNOsudoers.sh ausführen!"
echo "Ende der Installation. Bitte als root den Script nvidiaNOsudoers.sh ausführen!"  >> ~/Installation.log
echo "******************************************************************************"
sudo reboot


