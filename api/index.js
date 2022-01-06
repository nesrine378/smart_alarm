var express = require('express');
require('dotenv').config();
const {PythonSell} = require("python-shell");
const config = require('./config');
const helmet = require("helmet");
const fs = require('fs')

const key_file = process.env.KEY_FILE || config["key-file"]
const cert_file = process.env.CERT_FILE || config["cert-file"]

const options = {
  key: fs.readFileSync(key_file),
  cert: fs.readFileSync(cert_file),
 
}


var app = express();
app.use(helmet());
const server = tls.createServer(options, app);



const mongoose = require("mongoose");
mongoose.connect(
    process.env.DB_HOST || config.main_db_url,
    {
      useNewUrlParser: true,
      useUnifiedTopology: true
    }
);
const port = process.env.PORT || config.port
const bodyParser = require('body-parser')
app.use(bodyParser.urlencoded({extended: true}))
app.use(bodyParser.json())

var cors = require('cors')
app.use(cors())



app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
app.use('/', require('./routes/user.routes.js'))
app.use(express.static('upload/images'));
app.use('/', require('./routes/profile.routes.js'))
app.use(express.static('assets'));

server.listen(port, (error) => {
  if (error) {
      console.log("An error occured", error);
  } else {
      console.log("Server Succesfully connected");
  }
});