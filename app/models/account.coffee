module.exports =

  load: (mongoose) ->

    schema = new mongoose.Schema
      nickname: String

    mongoose.model 'Account', schema
