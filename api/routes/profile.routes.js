const express= require('express')
const multer=require('multer')
const path= require('path')
var router = express.Router();
const profileModel = require('../models/profile.model');
const mongoose= require('mongoose');
var cors = require('cors')
router.use(cors())




const storage = multer.diskStorage({
    destination: './upload/images',
    filename: (req, file, cb) => {
        return cb(null , `${file.fieldname}${Date.now()}${path.extname(file.originalname)}.jpg` )

    }
})




const fileFilter = (req, file, cb) => {
    // reject a file
    if (file.mimetype === 'image/jpeg' || file.mimetype === 'image/png' || file.mimetype === 'application/octet-stream') {
      cb(null, true);
    } else {
      cb(null, false);
    }
  };

  const upload = multer({
    storage: storage,
    limits: {
       fileSize: 1024 * 1024 * 5
     },
     fileFilter: fileFilter
  });





  router.get('/image',async(req, res)=>{
    //res.json({image: 'CORS enabled'})
    const image = await profileModel.find()
    res.json(image)
    
   })

  router.get("/getallprofiles/", (req, res, next) => {
    
  

    profileModel.find()
      .select("username CreatedByUsername  _id image")
      .exec()
      .then(docs => {
        const response = {
          count: docs.length,
          profiles: docs.map(doc => {
            return {
                username: doc.username,
                CreatedByUsername : doc.CreatedByUsername,
                image: doc.image,
              _id: doc._id,
              
            };
          })
        };
        //   if (docs.length >= 0) {
        res.status(200).json(response);
        //   } else {
        //       res.status(404).json({
        //           message: 'No entries found'
        //       });
        //   }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({
          error: err
        });
      });
  });

// router.post("/upload", upload.single('image'), (req, res) => {
  

//     const profile = new profileModel({
//       _id: new mongoose.Types.ObjectId(),
//       username: req.body.username,
//       CreatedByUsername: req.body.CreatedByUsername,
//       image: 'cccccc'
      
//     });
//     profile
//       .save()
//       .then(result => {
//         console.log(result);
//         res.status(201).json({
//           message: "Profile created successfully !",
//           createdProduct: {
//             username: result.username,
//             CreatedByUsername: result.CreatedByUsername,
//             image: result.image,
//               _id: result._id,

              
//           }
//         });
//       })
//       .catch(err => {
//         console.log(err);
//         res.status(500).json({
//           error: err
//         });
//       });
//   });

router.post('/upload', upload.single('image'), async(req, res, next) => {
  const file = req.file
  


  if (!file) {
    const error = new Error('Please upload a file')
    error.httpStatusCode = 400
    return next("hey error")
  }
  
  

    const imagepost= new profileModel({
      username: req.body.username,
      CreatedByUsername : req.body.CreatedByUsername,
      image: file.path
    })
    const savedimage= await imagepost.save()
    res.json(savedimage)
  
})


  router.get("/getprofile/:UserName", (req, res, next) => {
    const UserName = req.params.UserName;
    profileModel.findByCurrentUser(UserName)
      .select('username  CreatedByUsername _id image')
      .exec()
      .then(doc => {
        console.log("From database", doc);
        if (doc) {
          res.status(200).json({
              profile: doc,
              
          });
        } else {
          res
            .status(404)
            .json({ message: "No valid entry found for provided ID" });
        }
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({ error: err });
      });
  });


  router.delete("/deleteprofile/:profileId", (req, res, next) => {
    const id = req.params.profileId;
    Product.remove({ _id: id })
      .exec()
      .then(result => {
        res.status(200).json({
            message: 'profile deleted',
            
        });
      })
      .catch(err => {
        console.log(err);
        res.status(500).json({
          error: err
        });
      });
  });


module.exports = router;