touch ~/Installation.log
touch ~/tmp_bashrc

echo 'export PATH=/home/nvidia/cmake-3.17.0/bin/:/home/nvidia/.local/bin/:$PATH' >> ~/.bashrc
echo 'export PATH=/home/nvidia/cmake-3.17.0/bin/:/home/nvidia/.local/bin/:$PATH' >> ~/tmp_bashrc
eval "$(cat ~/.bashrc | tail -n +1)"
source ~/tmp_bashrc
sudo apt -y autoremove
echo "11.1 von 26: Pfadprüfung - Pfad ist gesetzt auf:" >> ~/Installation.log
echo $PATH >> ~/Installation.log

echo "11 von 26: Pythonpakete und Tools" >> ~/Installation.log
wget https://bootstrap.pypa.io/get-pip.py
sudo python3 get-pip.py
rm get-pip.py

echo "12 von 26: Virtuelle Umgebung installieren, anpassen und aktivieren" >> ~/Installation.log
sudo pip install virtualenv virtualenvwrapper
echo '#virtualenv and virtualenvwrapper' >> ~/tmp_bashrc
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/tmp_bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/tmp_bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/tmp_bashrc
echo '#virtualenv and virtualenvwrapper' >> ~/.bashrc
echo 'export WORKON_HOME=$HOME/.virtualenvs' >> ~/.bashrc
echo 'export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3' >> ~/.bashrc
echo 'source /usr/local/bin/virtualenvwrapper.sh' >> ~/.bashrc

source /usr/local/bin/virtualenvwrapper.sh
echo "12.1 von 26: Environmentprüfung - gesetzt auf:" >> ~/Installation.log
echo $WORKON_HOME >> ~/Installation.log
echo $VIRTUALENVWRAPPER_PYTHON >> ~/Installation.log

echo "13 von 26: Virtuelle Umgebung bauen" >> ~/Installation.log
eval "$(cat ~/.bashrc | tail -n +3)"
source ~/tmp_bashrc
#chmod a+x ~/.bashrc
#PS1='$ '
#source ~/.bashrc
mkvirtualenv py3cv4  -p python3
workon py3cv4
