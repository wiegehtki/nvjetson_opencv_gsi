# Highspeed - Modus setzen
grep -q Xavier /proc/device-tree/model && sudo nvpmodel -m 2
grep -q Nano /proc/device-tree/model   && sudo nvpmodel -m 0
sudo jetson_clocks
sudo nvpmodel -q

# Objekterkennung mit YOLOv4
./darknet detector demo ./cfg/coco.data ./cfg/yolov4.cfg ./YoloWeights/yolov4.weights http://192.168.254.62:8080/video?dummy=param.mjpg -i 0

# Beispiel für YOLOv3
#./darknet detector demo ./cfg/coco.data ./cfg/yolov3-tiny.cfg ./YoloWeights/yolov3-tiny.weights http://192.168.254.62:8080/video?dummy=param.mjpg -i 0

# Zurück auf Standard
grep -q Xavier /proc/device-tree/model && sudo nvpmodel -m 3
grep -q Nano /proc/device-tree/model   && sudo nvpmodel -m 1
sudo nvpmodel -q
