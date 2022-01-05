var mongoose = require('mongoose')

var ProfileSchema = new mongoose.Schema({
        username: {type:String},
        CreatedByUsername : {type:String},
        image:{type:String},
        //location:String,
        created_at:{type:Date, default:Date.Now},
      
    });

    ProfileSchema.statics.createIdentity = (infos)=> {
    const profile = new mongoose.model("Profile", ProfileSchema)(infos);
    return profile.save();
};



ProfileSchema.virtual('id').get(function (){
    return this._id.toHexString();
});

ProfileSchema.set('toJSON',{virtuals : true});


ProfileSchema.statics.findByUsername = (username)=> {
    return mongoose.model("Profile", ProfileSchema).find({username : username});
};

ProfileSchema.statics.findByCurrentUser = (username)=> {
    return mongoose.model("Profile", ProfileSchema).find({CreatedByUsername : username});
};


ProfileSchema.statics.Delete = (id)=> {
    console.log(id)
    return mongoose.model("Profile", ProfileSchema).deleteOne({_id : ObjectId(id)});
}



module.exports = mongoose.model('Profile',ProfileSchema);