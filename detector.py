import cv2
import numpy as np
import os
import time
import firebase_admin
from firebase_admin import firestore

np.random.seed(20)

class Detector:
    def __init__(self, model_path, config_path, video_path, classes_path, output_dir, firebase, snapshot_interval=5):
        self.model_path = model_path
        self.config_path = config_path
        self.video_path = video_path
        self.classes_path = classes_path
        self.output_dir = output_dir
        self.snapshot_interval = snapshot_interval
        self.last_snapshot_time = time.time()
        self.focal_length = 700  # Focal length of your camera (adjust accordingly)
        self.firebase = firebase
            
        self.net = cv2.dnn_DetectionModel(self.model_path, self.config_path)
        self.net.setInputSize(320, 320)
        self.net.setInputScale(1.0 / 127.5)
        self.net.setInputMean((127.5, 127.5, 127.5))
        self.net.setInputSwapRB(True)
        
        self.readClasses()
    
    def readClasses(self):
        with open(self.classes_path, 'r') as f:
            self.classes = f.read().splitlines()
            
        self.classes.insert(0, '__background__')
        
        self.colorList = np.random.uniform(0, 255, size=(len(self.classes), 3))
        
        print(self.classes)
    
    def calculateDistance(self, bbox):
        # Calculate the object's distance from the camera
        # Note: This calculation is a rough estimate and may not be accurate without camera parameters
        object_width = bbox[2]
        distance = (self.focal_length * 5.8) / object_width  # Adjust constant 8 based on your setup
        return distance
    
    def onVideo(self):
        cap = cv2.VideoCapture(self.video_path)
    
        if not cap.isOpened():
            print("Error opening video stream or file")
            return
    
        while True:
            success, image = cap.read()
            
            if not success:
                break
            
            classLabelIDs, confidences, bboxs = self.net.detect(image, confThreshold=0.5)
            
            bboxs = list(bboxs)
            confidences = list(np.array(confidences).reshape(1, -1)[0])
            confidences = list(map(float, confidences))
            
            bboxIdx = cv2.dnn.NMSBoxes(bboxs, confidences, score_threshold=0.5, nms_threshold=0.2)
            
            if len(bboxIdx) != 0:
                for i in range(len(bboxIdx)):
                    bbox = bboxs[np.squeeze(bboxIdx[i])]
                    classConfidence = confidences[np.squeeze(bboxIdx[i])]
                    classLabelID = np.squeeze(classLabelIDs[np.squeeze(bboxIdx[i])])
                    classLabel = self.classes[classLabelID]
                    classColor = [int(c) for c in self.colorList[classLabelID]]
                    
                    displayText = "{}: {:.2f}".format(classLabel, classConfidence)
                    
                    x, y, w, h = bbox
                    
                    cv2.rectangle(image, (x, y), (x+w, y+h), color=classColor, thickness=1)
                    cv2.putText(image, displayText, (x, y-10), cv2.FONT_HERSHEY_PLAIN, 1, classColor, 2)
                    
                    # Calculate and display object distance
                    distance = self.calculateDistance(bbox)
                    distance_text = "Distance: {:.2f} feets".format(distance)
                    cv2.putText(image, distance_text, (x, y-30), cv2.FONT_HERSHEY_PLAIN, 1, classColor, 2)
                    
                    # Check if the detected object is a person (classLabelID 1 represents person in COCO dataset)
                    if classLabelID == 1 and time.time() - self.last_snapshot_time >= self.snapshot_interval:
                        # Save snapshot
                        timestamp = time.strftime("%Y%m%d-%H%M%S")
                        filename = os.path.join(self.output_dir, f"person_snapshot_{timestamp}.jpg")
                        cv2.imwrite(filename, image)
                        print(f"Snapshot saved: {filename}")
                        self.last_snapshot_time = time.time()

                        # Update detected time and date in Firebase Realtime Database
                        db = self.firebase.database()
                        db.child("detections").child("Arduino").update({
                            'timestamp': timestamp,
                            'detected_date': time.strftime("%Y-%m-%d"),
                            'detected_time': time.strftime("%H:%M:%S"),
                            'distance' : "{:.2f} m".format(distance),
                            'person' : 1
                        })
                    
                        # Send detected data to Firestore
                        db_firestore = firestore.client()
                        detections_ref = db_firestore.collection("Detections_mobile")
                        detection_data = {
                            'timestamp': timestamp,
                            'detected_date': time.strftime("%Y-%m-%d"),
                            'detected_time': time.strftime("%H:%M:%S"),
                            'distance' : "{:.2f} m".format(distance),
                            'person' : 'yes'
                        }
                        detections_ref.add(detection_data)
                    
            cv2.imshow("result", image)
            
            key = cv2.waitKey(1) & 0xFF
            if key == ord("q"):
                break
        
        cap.release()
        cv2.destroyAllWindows()
