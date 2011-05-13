module.exports =

  load: (mongoose) ->

    ObjectId = mongoose.Schema.ObjectId

    schema = new mongoose.Schema
      number: String
      nickname: String
      member_id: ObjectId

    mongoose.model 'Account', schema
