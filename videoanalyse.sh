sudo jetson_clocks

# Highspeed - Modus setzen
grep -q Jetson-AGX /proc/device-tree/model && sudo nvpmodel -m 3
grep -q Xavier /proc/device-tree/model     && sudo nvpmodel -m 2
grep -q Nano /proc/device-tree/model       && sudo nvpmodel -m 0
sudo jetson_clocks
sudo nvpmodel -q

# Video analysieren mit YOLOv4
./darknet detector demo ./cfg/coco.data ./cfg/yolov4.cfg ./YoloWeights/yolov4.weights ~/darknet/Videos_Eingabe/traffic-mini.mp4 -i 0  -thresh 0.25

# Zurück auf Standard
grep -q Jetson-AGX /proc/device-tree/model && sudo nvpmodel -m 1
grep -q Xavier /proc/device-tree/model     && sudo nvpmodel -m 3
grep -q Nano /proc/device-tree/model       && sudo nvpmodel -m 1
sudo nvpmodel -q
