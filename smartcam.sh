sudo jetson_clocks
./darknet detector demo ./cfg/coco.data ./cfg/yolov4.cfg ./YoloWeights/yolov4.weights http://192.168.254.62:8080/video?dummy=param.mjpg -i 0
#./darknet detector demo ./cfg/coco.data ./cfg/yolov3-tiny.cfg ./YoloWeights/yolov3-tiny.weights http://192.168.254.62:8080/video?dummy=param.mjpg -i 0
