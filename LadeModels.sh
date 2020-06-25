#!/bin/sh
if [ "$(whoami)" != "nvidia" ]; then
        echo "Script muss als nvidia ausgeführt werden!"
        exit 255
fi

cd ~
(ls ~/darknet/YoloWeights >> /dev/null 2>&1 && echo Verzeichnis existiert bereits) || echo Lege YoloWeights - Verzeichnis an && mkdir ~/darknet/YoloWeights
(ls ~/darknet/YoloWeights/yolov4.weights >> /dev/null 2>&1 && echo yolov4.weights bereits vorhanden) || echo Bitte Geduld, lade yolov4.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1cewMfusmPjYWbrnuJRuKhPMwRe_b9PaT" -O ~/darknet/YoloWeights/yolov4.weights && rm -rf /tmp/cookies.txt
(ls ~/darknet/YoloWeights/yolov3.weights >> /dev/null 2>&1 && echo yolov3.weights bereits vorhanden) || echo Bitte Geduld, lade yolov3.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=10NEJcLeMYxhSx9WTQNHE0gfRaQaV8z8A" -O ~/darknet/YoloWeights/yolov3.weights && rm -rf /tmp/cookies.txt
(ls ~/darknet/YoloWeights/yolov3-tiny.weights >> /dev/null 2>&1 && echo yolov3-tiny.weights bereits vorhanden) || echo Bitte Geduld, lade yolov3-tiny.weights && wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=12R3y8p-HVUZOvWHAsk2SgrM3hX3k77zt" -O ~/darknet/YoloWeights/yolov3-tiny.weights && rm -rf /tmp/cookies.txt

