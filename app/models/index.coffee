mongoose = require 'mongoose'

mongoose.connect 'mongodb://localhost/hyperlocal_api'

exports.load = (config) ->

  config.mongoose = mongoose

  mongoose.connect config.database

  config.models =

    Account: require('./account').load(mongoose)
    Member: require('./member').load(mongoose)
