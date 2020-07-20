# nvjetson_opencv_gsi 
# Objekterkennung mit YOLO und OpenCV
### Installation von OpenCV 4.3 und YOLOv3 + YOLOv4 auf dem NVIDIA Jetson Nano 

Die passenden Videos dazu (und weitere) findet Ihr auf https://wiegehtki.de
* **Intro:** https://www.youtube.com/watch?v=_ndzsZ66SLQ
* **Basiswissen Objekterkennung mit YOLO:** https://www.youtube.com/watch?v=WXuqsRGIyg4&t=1586s
* **Technologischer Deep Dive in YOLO:** https://www.youtube.com/watch?v=KMg6BwNDqBY
* **Installation dieses Repository's auf dem NANO:** https://www.youtube.com/watch?v=ZuGNQYPJqKk&t=2793s

#### Das passende Image (4.4 vom 07.07.2020) für den Nano könnt Ihr hier herunterladen: https://developer.nvidia.com/jetson-nano-sd-card-image 
#### Unterstützung u.a. für:
* **CUDA 10.2**
* **cuDNN 8.0**
* **TensorRT 7.1.3**


Verwendet bitte als Benutzer **nvidia** da leider etliche Scripte, die man im Internet findet und verwenden möchte, diesen Benutzer hardcodiert haben.

#### Die Geschwindigkeit des Nano kann mit folgenden Befehlen hochgesetzt werden:

```
sudo nvpmodel -m 0
sudo jetson_clocks
```

#### Zur Installation könnt ihr wie folgt vorgehen, dazu alle Befehle im Terminal ausführen:

1.  Einloggen und das **Terminal** öffnen
2.  **Einstellungen -> Terminal -> Scrolling** deaktivieren (Limit auf 10000 lines ausschalten)
3.  Im Terminal dann folgende Befehle eingeben:
```
       cd ~
       git clone https://github.com/wiegehtki/nvjetson_opencv_gsi.git
       cp nvjetson_opencv_gsi/*sh .
       sudo chmod +x *sh
       sudo su
       ./nvidia2sudoers.sh
       exit 
       cd ~
       ./Installv2.3.6.sh
```
**Wichtig:** Der Benutzer **nvidia** wird dabei in die Superuser - Gruppe aufgenommen. Der Hintergrund ist, dass die Installation lange laufen wird (ca. 6-7 Stunden) und Ihr ansonsten immer wieder das Kennwort des Benutzers eingeben müsst damit einige Installationsschritte mit **sudo** - Rechten durchgeführt werden können. Das ist nervig und kann entsprechend mit den vorgenannten Schritten vermieden werden. Ihr könnt die sudo - Rechte nach der Installation bei Bedarf wieder wegnehmen, indem ihr im Terminal folgende Befehle ausführt:
```
   cd ~
   sudo su
   ./nvidiaNOsudoers.sh
```

#### Kontrolle des Installationsfortschritts

Ein weiteres Terminalfenster öffnen und mit `cat Installation.log` den Fortschritt der Installation kontrollieren.
   
Nach der Installation sollte der Rechner automatisch einen `reboot` ausführen.
Falls nicht, Fehler lokalisieren und ggfs. beheben.
  
Die **.weights - Dateien** sollten über den Installationsscript geladen werden.
Falls nicht, hier die Download-Links:

1. Download yolov3.weights: https://drive.google.com/file/d/10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A/view?usp=sharing
2. Download yolov3-tiny.weights: https://drive.google.com/file/d/12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt/view?usp=sharing
3. Download yolov4.weights: https://drive.google.com/file/d/1Z-n8nPO8F-QfdRUFvzuSgUjgEDkym0iW/view?usp=sharing

Die Dateien müssen unter **~/darknet/YoloWeights/** abgelegt werden.


### Bekannte Fehler und deren Behebungen
* **Hänger beim Image vom April 2020?:** Version JP 4.4 vom 07.07.2020 oder Neuer benutzen
* **Installation läuft durch aber beim Aufruf von `./smartcam.sh` kommen Meldungen bezüglich fehlender Dateien:** Wahrscheinlich passt die CUDA- bzw. cuDNN-Versionen nicht mehr zur vorkompilierten YOLO - Installation. Folgende Befehle sollten diesen Fehler beheben:
```
    cd ~/nvjetson_opencv_gsi/obj
    rm *o
    cd ..
    make
```
* **Es wird empfohlen keinen `sudo apt -y autoremove` durchzuführen. Es gab Fälle, in denen später noch benötigte Pakete entfernt wurden und die Installation entsprechend korrigiert werden musste.**


