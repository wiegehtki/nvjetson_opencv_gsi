from imageai.Detection import VideoObjectDetection
import os
import tensorflow as tf

execution_path = os.getcwd()

session_config = tf.ConfigProto()
session_config.gpu_options.per_process_gpu_memory_fraction = 0.3

detector = VideoObjectDetection()
detector.setModelTypeAsYOLOv3()
detector.setModelPath( os.path.join(execution_path , "yolo.h5"))
detector.loadModel()

video_path = detector.detectObjectsFromVideo(input_file_path=os.path.join( execution_path, "NewYorkCity-1044.mp4"),
                                output_file_path=os.path.join(execution_path, "NewYorkCity-1044_detected_1.mp4")
                                , frames_per_second=30, log_progress=True)
print(video_path)

