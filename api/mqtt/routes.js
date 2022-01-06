var express = require('express');
const mqtt = require('mqtt');

var router = express.Router();
var MqttData = require('mqtt/controller.js')
/* GET mqtt listing. */
var topic='hello';
var mqttData = new MqttData();
console.log("mqtt is connected")
//Connection to MQTT

    const client = mqtt.connect('mqtt://102.133.191.61:1883', {

  username: 'malek',
  password: 'malek'
});


//On received MQTT message
client.on('connect',() => {
    console.log('connected')
    client.subscribe(['hello'], () => {
        console.log('subscribe to topic')
    })
})
client.on('message', function (topic, message) {
    //Saving received data to MongoDB
    var mongomqttdata = {
      topic: topic,
      payload: message.toString()
    };
    const saved = mqttData.addmqtt(mongomqttdata)
    console.log("a new message is received from your sensors")
  });

router.get('/',[mqttData.getResults]);

module.exports = router;
