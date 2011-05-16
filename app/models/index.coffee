mongoose = require 'mongoose'
_ = require 'underscore'

mongoose.connect 'mongodb://localhost/hyperlocal_api'

exports.load = (config) ->

  config.mongoose = mongoose

  mongoose.connect config.database

  config.models = {}

  _.each ['Account', 'Member'], (name) ->
    config.models[name] = mongoose.model name, require("./#{name.toLowerCase()}")
