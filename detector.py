import cv2
import numpy as np
import os
import time
import pyrebase
import threading

from firebase_admin import firestore



np.random.seed(20)

class Detector:
    def __init__(self, model_path, config_path, video_path, classes_path, output_dir, firebase_config, snapshot_interval=5):
        self.model_path = model_path
        self.config_path = config_path
        self.video_path = video_path
        self.classes_path = classes_path
        self.output_dir = output_dir
        self.snapshot_interval = snapshot_interval
        self.last_snapshot_time = 0  # Initialize last detection time to 0
        self.focal_length = 700  

        self.firebase = pyrebase.initialize_app(firebase_config)
        self.db = self.firebase.database()
        self.firestore = firestore.client()

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
    
    # Calculate the object's distance from the camera
    def calculateDistance(self, bbox):
         
        object_width = bbox[2]
        distance = (self.focal_length * 5.8) / object_width  
        return distance
    
    #reset camera = 0 when timeout for stop continuously update distance
    def reset_elephant_after_timeout(self):
        time.sleep(15)  # Wait for 15 seconds
        db = self.firebase.database()
        db.child("detections").child("Arduino").update({'elephant': 0})
    
    #Open OpenCV Feed
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
            
            if len(classLabelIDs) > 0:
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

                        # Check if the detected object is a elephant (classLabelID 22 represents elephant in COCO dataset)
                        if classLabelID == 22 and (time.time() - self.last_snapshot_time >= 30 or self.last_snapshot_time == 0):  # Check if person detected and 30 seconds elapsed or first detection
                            # Save snapshot
                            timestamp = time.strftime("%Y%m%d-%H%M%S")
                            filename = os.path.join(self.output_dir, f"person_snapshot_{timestamp}.jpg")
                            cv2.imwrite(filename, image)
                            print(f"Snapshot saved: {filename}")
                            self.last_snapshot_time = time.time()  # Update last detection time

                            # Fetch distance and location from Realtime Database
                            detection_data = self.db.child("dev_data").get().val()

                            if detection_data:
                                location = detection_data.get('location', 'Habarana')
                                distance = detection_data.get('distance', 0.0)
                                latitude = detection_data.get('latitude', 0.0)
                                longitude = detection_data.get('longitude', 0.0)
                            else:
                                location = 'Habarana'
                                distance = 0.0

                            # Update detected time and date in Firebase Realtime Database
                            self.db.child("detections").child("Arduino").update({
                                'timestamp': timestamp,
                                'elephant' : 1
                            })

                            reset_thread = threading.Thread(target=self.reset_elephant_after_timeout)
                            reset_thread.start()

                            # Send detected data to Firestore
                            detections_ref = self.firestore.collection("Detections_mobile")
                            detection_data = {
                                'timestamp': timestamp,
                                'detected_date': time.strftime("%Y-%m-%d"),
                                'detected_time': time.strftime("%H:%M:%S"),
                                'distance' : "{:.2f} m".format(distance),
                                'comment' : 'Elephant detected',
                                'username' : 'CCTV',
                                'location' : 'Habarana'  ,
                                'latitude' : str(latitude),
                                'longitude' :str(longitude) 
                            }
                            detections_ref.add(detection_data)

            cv2.imshow("result", image)
            
            #stop the app
            key = cv2.waitKey(1) & 0xFF
            if key == ord("q"):
                break
        
        cap.release()
        cv2.destroyAllWindows()

