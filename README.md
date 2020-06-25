# nvjetson_opencv_gsi
Installation von OpenCV und YOLOv3 + YOLOv4 auf dem NVIDIA Jetson Nano 

Den passenden Video dazu findet Ihr auf https://wiegehtki.de (verfügbar ab 03.07.2020)

Das passende Image für den Nano runter laden: https://developer.nvidia.com/jetson-nano-sd-card-image-r3231

Wichtig: Es wird bewusst eine ältere Version verwendet, da mit der 04/2020 Version mein Nano etwas ruckelte.

Verwendet bitte als Benutzer 'nvidia' da etliche Scripte die man im Internet findet und verwenden möchte leider
diesen Benutzer hardcodiert haben.

Die Geschwindigkeit des Nano kann mit folgenden Befehlen hochgesetzt werden:

sudo nvpmodel -m 0
sudo jetson_clocks

Zur Installation könnt ihr wie folgt vorgehen, alle Befehle im Terminal ausführen:

1. sudo apt -y install git-all doxygen build-essential nghttp2 libnghttp2-dev libssl-dev
2. git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git
3. cd ~
4. cp nvjetson_opencv_gsi/*sh .
5. sudo chmod +x *.sh
6. sudo su
7.  ./nvidia2sudoers.sh
8. reboot

< Terminal starten >
9. cd ~
10. ./Installv2.3.8.sh

Nach der Installation, die mehrere Stunden dauern wird:
11. sudo reboot

< Terminal starten >
12. cd ~
13. sudo su
14. ./Finalisieren.sh
15. reboot
    
Die .weights - Dateien sollten über den Installationsscript geladen werden.
Falls nicht, hier die Download-Links:

1. Download yolov3.weights: https://drive.google.com/file/d/10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A/view?usp=sharing
2. Download yolov3-tiny.weights: https://drive.google.com/file/d/12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt/view?usp=sharing
3. Download yolov4.weights: https://drive.google.com/file/d/1Z-n8nPO8F-QfdRUFvzuSgUjgEDkym0iW/view?usp=sharing

Die Dateien müssen unter ~/darknet/YoloWeights/ abgelegt werden.



Wichtig: Der nvidia - Benutzer ist als sudo hochgestuft um die Installation automatisch ablaufen lassen zu können! 
Ihr könnt das wegnehmen, indem ihr im Terminal folgendes eingeb:
   sudo su
   ./nvidiaNOsudoers.sh
