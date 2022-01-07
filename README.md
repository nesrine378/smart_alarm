# Cloud of Things Application
## Description
It's about a Smart alarm application using clouf of things. The goal is to create a continuous and efficient video surveillance system. Our approach is based on the use of smartphones, with devices such as (camera, alarm, Raspberry Pi board..) as additional peripherals.

## Technologies

- Front-End : Flutter
- Middleware : Node.js
- Backend : Raspberry pi 4 , mosquitto
- Database : mongoDB
![architecture](https://user-images.githubusercontent.com/96119446/148507083-7e4dc3cc-ad89-4c85-a18c-f3e71cb2971e.PNG)

## Technical documentation 

### how to install SmartAlarm ?
######  Server side :
- Download and Install node.js :

`wget -qO- https://deb.nodesource.com/setup_14.x | sudo -E bash -`

`sudo apt install -y nodejs`

- Run the server :

`npm start` 

######  Client side :
- Run the application :

`flutter run `

## Deployment
- The NodeJS server part is deployed on an Azure virtual machine with an Ubuntu 20.4 OS and accessible via the URL cotsmartalarm.me .
- This server is secured with a Wildard SSL certificate associated with an rsa 4096 key, issued by Let's Encrypt and generated with the following command:
`sudo certbot certonly --manual -d *.$cotsmartalarm.me -d $cotsmartalarm.me --agree-tos --manual-public-ip-logging-ok --preferred-challenges dns-01 --server https://acme-v02.api.letsencrypt.org/directory --register-unsafely-without-email --rsa-key-size 4096`

![test_SSLlab_A](https://user-images.githubusercontent.com/96119446/148534273-a496aa41-8546-45df-9df5-bf09256a4519.PNG)


