import os
import time
import pyrebase
import cv2
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from detector import Detector

# Firebase configuration
firebase_config = {
  "apiKey": "AIzaSyCMU5TTRgVmvT2GeZtfAKWntoHRlKlmQ5w",
  "authDomain": "test2-f16fb.firebaseapp.com",
  "projectId": "test2-f16fb",
  "databaseURL" : "https://test2-f16fb-default-rtdb.asia-southeast1.firebasedatabase.app/",
  "storageBucket": "test2-f16fb.appspot.com",
  "messagingSenderId": "367885456902",
  "appId": "1:367885456902:web:fa82f25d2fb99561931587"
}

firebase = pyrebase.initialize_app(firebase_config)

cred = credentials.Certificate(r"C:\Users\Facebook Ad\Desktop\iot cam working\test2-f16fb-firebase-adminsdk-zszr4-3465b67c49.json")
firebase_admin.initialize_app(cred)


def main():
    
    video_path = "rtsp://192.168.8.130/live/ch00_0"
    output_dir = "snapshots"
    config_path = os.path.join("model_data", "ssd_mobilenet_v3_large_coco_2020_01_14.pbtxt")
    model_path = os.path.join("model_data", "frozen_inference_graph.pb")
    classes_path = os.path.join("model_data", "coco.names")
    
    # Create output directory if it does not exist
    os.makedirs(output_dir, exist_ok=True)

    # Initialize detector
    detector = Detector(model_path, config_path, video_path, classes_path, output_dir, firebase)
    
    # Run detection
    detector.onVideo()

if __name__ == "__main__":
    main()