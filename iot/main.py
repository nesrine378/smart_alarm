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
import psycopg2
import datetime, uuid
import time
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

#Connect to MongoDB
conn = "mongodb+srv://malek:Malek.fakhfakh1@cluster0.ygipb.mongodb.net/SmartAlarmDB?retryWrites=true&w=majority"
connection = MongoClient(conn)

cursor = conn.cursor()

cap = cv2.VideoCapture(0)
while True:
    ret, frame = cap.read()
  
    ################################################
    d ='person'
    for i in range(10):
        if d =='person':
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
            if key ==ord('q'):
                break
            #cv2.rectangle(frame, (x, y-3), (x+150, y+23),BLACK,-1 )
    cv2.imshow('frame',frame)
    
    key = cv2.waitKey(1)
    if key ==ord('q'):
        break
cv2.destroyAllWindows()
cap.release()
