import cv2
import databases
import sqlalchemy
import face_recognition
import numpy as np
from fastapi import FastAPI
from pydantic import BaseModel, Field
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from typing import List
from passlib.context import CryptContext
import datetime
from sqlalchemy.sql import select
import pymongo
from pymongo import MongoClient
import datetime, uuid
import time

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
conn = "mongodb+srv://malek:Malek.fakhfakh1@cluster0.ygipb.mongodb.net/SmartAlarmDB?retryWrites=true&w=majority"
connection = MongoClient(conn)


cursor = conn.cursor()

CONFIDENCE_THRESHOLD = 0.4
NMS_THRESHOLD = 0.3
COLORS = [(255,0,0),(255,0,255),(0, 255, 255), (255, 255, 0), (0, 255, 0), (255, 0, 0)]
GREEN =(0,255,0)
BLACK =(0,0,0)
# defining fonts 
FONTS = cv2.FONT_HERSHEY_COMPLEX
class_names = []
with open("classes.txt", "r") as f:
    class_names = [cname.strip() for cname in f.readlines()]
#  setttng up opencv net
yoloNet = cv2.dnn.readNet('yolov5-tiny.weights', 'yolov5-tiny.cfg')

yoloNet.setPreferableBackend(cv2.dnn.DNN_BACKEND_CUDA)
yoloNet.setPreferableTarget(cv2.dnn.DNN_TARGET_CUDA_FP16)

model = cv2.dnn_DetectionModel(yoloNet)
model.setInputParams(size=(416, 416), scale=1/255, swapRB=True)

# object detector funciton /method
def object_detector(image):
    classes, scores, boxes = model.detect(image, CONFIDENCE_THRESHOLD, NMS_THRESHOLD)
    # creating empty list to add objects data
    data_list =[]
    for (classid, score, box) in zip(classes, scores, boxes):
        # define color of each, object based on its class id 
        color= COLORS[int(classid) % len(COLORS)]
        print(class_names)
        print('omar')
        print(classid)
        label = "%s : %f" % (class_names[classid], score)

        # draw rectangle on and label on object
        cv2.rectangle(image, box, color, 2)
        cv2.putText(image, label, (box[0], box[1]-14), FONTS, 0.5, color, 2)
    
        # getting the data 
        # 1: class name  2: object width in pixels, 3: position where have to draw text(distance)
        if classid ==0: # person class id 
            data_list.append([class_names[classid], box[2], (box[0], box[1]-2)])
        #elif classid ==67:
           # data_list.append([class_names[classid[0]], box[2], (box[0], box[1]-2)])
        #elif classid ==2:
            #data_list.append([class_names[classid[0]], box[2], (box[0], box[1]-2)])
        #elif classid ==5:
            #data_list.append([class_names[classid[0]], box[2], (box[0], box[1]-2)])
        #elif classid ==7:
            #data_list.append([class_names[classid[0]], box[2], (box[0], box[1]-2)])
        #elif classid ==3:
            #data_list.append([class_names[classid[0]], box[2], (box[0], box[1]-2)])
        # return list 
    return data_list

cap = cv2.VideoCapture(0)
while True:
    ret, frame = cap.read()
    #frame = cv2.imread('img_test/car and bus.png')
    #frame = cv2.imread('img_test/person.png')
    #frame = cv2.imread('img_test/Capture.png')
    #frame = cv.imread('img_test/Capture.png')


    #frame = cv.VideoCapture('test.mp4')
    #frame = cv.imread('img_test/test.mp4')
    ################################################
    data = object_detector(frame)
    for d in data:
        if d[0] =='person':
            ch=""
            start=time.time()
            #traitement de visage
            cap = cv2.VideoCapture(0)
            sampleNum=0
            while(True):
                success, img = cap.read()
                imgS = cv2.resize(img,(0,0),None,0.25,0.25)
                imgS = cv2.cvtColor(imgS , cv2.COLOR_BGR2RGB)
                facesCurFrame = face_recognition.face_locations(imgS)
                encodesCurFrame = face_recognition.face_encodings(imgS,facesCurFrame)
    
                for (x,y,w,h) in facesCurFrame:
                    cv2.rectangle(img,(x,y),(x+w,y+h),(255,0,0),2)
                    sampleNum=sampleNum+1

                    #fin boucle pour 
                end=time.time()
                if cv2.waitKey(100) & 0xFF == ord('q'):
                    break
                elif sampleNum>0:
                    break

                #######################################################################################
                #elif(end-start>10):
                    #ch='Alerte'
                    #print(ch)
                    #break

                 #fin boucle while 

            l =[]
            for i in range (128):
                l.append(encodesCurFrame[0][i])
            w = np.array(l)
            w1=[]
            w1.append(w)

            #ch=""
            for i in l :
                ch=ch+str(i)+" "
            ch=ch[0:len(ch)-1]

            ###############

    
   

            lis = list(ch.split(" "))

    
            ll=[]
            for i in lis:
                ll.append(float(i))
    
            li=ll
    

    
    
            query = 'SELECT face FROM iot'
            cursor.execute(query)
            l1= cursor.fetchall()
            print(l1)
            query = 'SELECT name FROM iot'
            cursor.execute(query)
            classNames= cursor.fetchall()
            for i in range (len(classNames)):
                classNames[i]=classNames[i][0]
            for i in range(len(l1)):
                l1[i] = list(l1[i][0].split(" "))
                l1[i][0]=l1[i][0][1:]
                l1[i][127]=l1[i][127][:len(l1[i][127])-1]
                for j in range(len(l1[i])):
                    l1[i][j]=float(l1[i][j])
    
        
            encodeListknown=l1
  
            w = np.array(li)
            w1=[]
            w1.append(w)
            encodesCurFrame=w1
            ch=''
            for encodeFace in encodesCurFrame:
        
                matches = face_recognition.compare_faces(encodeListknown,encodeFace)
                faceDis = face_recognition.face_distance(encodeListknown,encodeFace)
        
                if min(faceDis)>0.7 :
                    print('ALERTE')
                    ch='ALERTE'
        
                    break
            
    #
            matchIndex = np.argmin(faceDis)
            name = classNames[matchIndex].upper()

            if matches[matchIndex]:
                name = classNames[matchIndex].upper()
        
                ch="l'utilisateur est "+ name
                print(name)
                print(ch)
            if (len(ch)!=0):
                break
            #fin traitement de visage
            print('ALERTE')
            x, y = d[2]
            cv2.rectangle(frame, (x, y-3), (x+150, y+23),BLACK,-1 )
    cv2.imshow('frame',frame)
    
    key = cv2.waitKey(1)
    if key ==ord('q'):
        break
cv2.destroyAllWindows()
cap.release()


