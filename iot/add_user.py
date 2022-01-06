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

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

#Connect to MongoDB
conn = "mongodb+srv://malek:Malek.fakhfakh1@cluster0.ygipb.mongodb.net/SmartAlarmDB?retryWrites=true&w=majority"
connection = MongoClient(conn)



cursor = conn.cursor()

cursor.execute('''DELETE FROM iot WHERE (iot.name='malek fakhfakh')''')

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
    if cv2.waitKey(100) & 0xFF == ord('q'):
        break
    elif sampleNum>0:
        break
    #fin boucle while 

l =[]
for i in range (128):
    l.append(encodesCurFrame[0][i])
w = np.array(l)
w1=[]
w1.append(w)

ch=""
for i in l :
    ch=ch+str(i)+" "
ch=ch[0:len(ch)-1]
print (ch)


gid = str(uuid.uuid1())
print ('donner le nom')
name=input()
print('donner le prénom')
last_name=input()
print('donner le mail')
mail=input()
print('donner le numéro de tel')
num=input()
gdate=str(datetime.datetime.now())
postgres_insert_query = ''' INSERT INTO iot  VALUES (%s,%s,%s,%s,%s,%s,%s)'''
cursor.execute(postgres_insert_query,(gid,name,last_name,ch,gdate,mail,num))
conn.commit()
query = "SELECT * FROM iot"
cursor.execute(query)
l2= cursor.fetchall()
